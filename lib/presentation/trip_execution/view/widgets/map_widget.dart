import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';

import '../../../../app/constants.dart';
import '../../../../domain/model/trip_details_model.dart';
import '../../../google_maps/model/maps_repo.dart';

class MapWidget extends StatefulWidget {
  final TripDetailsModel tripModel;
  final int? currentStepIndex;
  final String? currentTripStatus;

  MapWidget({
    Key? key,
    required this.tripModel,
    this.currentStepIndex,
    this.currentTripStatus,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  final controller = Completer<GoogleMapController>();
  MapsRepo mapsRepo = MapsRepo();

  LocationModel? currentLocation;
  List<LatLng> currentToPickupPolyline = [];
  List<LatLng> pickupToDestinationPolyline = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  // Store markers and polylines in state to ensure GoogleMap updates
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Map type state
  MapType _currentMapType = MapType.normal;
  bool _showLocationTiles = true;

  // Determine which mode we're in based on trip status (priority) or step index (fallback)
  bool get _isMovedToClientMode {
    // PRIORITY: Check trip status FIRST (most reliable)
    String? passedStatus = widget.currentTripStatus;
    String? modelStatus = widget.tripModel.tripDetails.tripStatus;
    String? status = passedStatus ?? modelStatus;

    // Debug: Log what we received
    debugPrint('[MapWidget] MAP MODE - status: ${status ?? "NULL"}, stepIndex: ${widget.currentStepIndex}');

    if (status == null || status.isEmpty) {
      print("⚠️ [MAP MODE] Status is null/empty, using step index");
      if (widget.currentStepIndex != null) {
        bool isMovedToClient = widget.currentStepIndex! <= 1;
        print(
            "🗺️ [MAP MODE] StepIndex-based: ${isMovedToClient ? 'MOVED_TO_CLIENT' : 'ARRIVED_PICKUP'} (Step: ${widget.currentStepIndex})");
        return isMovedToClient;
      }
      print("🗺️ [MAP MODE] Default: MOVED_TO_CLIENT (no status or step)");
      return true;
    }

    // Normalize status (trim whitespace, convert to uppercase for comparison)
    String normalizedStatus = status.trim().toUpperCase();

    // READY_FOR_TAKEOFF → MOVED_TO_CLIENT mode (show current → pickup)
    if (normalizedStatus == TripStatusConstants.READY_FOR_TAKEOFF) {
      print("🗺️ [MAP MODE] Status-based: MOVED_TO_CLIENT (Status: $status)");
      return true; // MOVED_TO_CLIENT mode (show current → pickup)
    }

    // HEADING_TO_PICKUP_POINT, ARRIVED_TO_PICKUP_POINT, HEADING_TO_DESTINATION → ARRIVED_PICKUP mode (show pickup → destination)
    if (normalizedStatus == TripStatusConstants.HEADING_TO_PICKUP_POINT ||
        normalizedStatus == TripStatusConstants.ARRIVED_TO_PICKUP_POINT ||
        normalizedStatus == TripStatusConstants.HEADING_TO_DESTINATION) {
      print("🗺️ [MAP MODE] Status-based: ARRIVED_PICKUP (Status: $status)");
      return false; // ARRIVED_PICKUP mode (show pickup → destination)
    }

    // Fallback: Use step index if status doesn't match known values
    print(
        "⚠️ [MAP MODE] Status '$status' doesn't match known values, using step index");
    if (widget.currentStepIndex != null) {
      bool isMovedToClient = widget.currentStepIndex! <= 1;
      print(
          "🗺️ [MAP MODE] StepIndex-based: ${isMovedToClient ? 'MOVED_TO_CLIENT' : 'ARRIVED_PICKUP'} (Step: ${widget.currentStepIndex}, Status: $status)");
      return isMovedToClient;
    }

    // Final fallback: default to MOVED_TO_CLIENT
    print("🗺️ [MAP MODE] Default: MOVED_TO_CLIENT (Status: $status)");
    return true;
  }

  @override
  void initState() {
    super.initState();
    // CRITICAL: Clear currentLocation immediately if in ARRIVED_PICKUP mode
    if (!_isMovedToClientMode) {
      currentLocation = null;
      currentToPickupPolyline.clear();
    }
    _initializeMap();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if step index or status changed
    bool stepIndexChanged =
        widget.currentStepIndex != oldWidget.currentStepIndex;
    bool statusChanged =
        (widget.currentTripStatus ?? widget.tripModel.tripDetails.tripStatus) !=
            (oldWidget.currentTripStatus ??
                oldWidget.tripModel.tripDetails.tripStatus);

    if (stepIndexChanged || statusChanged) {
      _resetState();
      _initializeMap();
    }
  }

  void _resetState() {
    currentLocation = null;
    currentToPickupPolyline.clear();
    pickupToDestinationPolyline.clear();
    _markers.clear();
    _polylines.clear();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  Future<void> _initializeMap() async {
    if (!mounted) return;

    // CRITICAL: Clear currentLocation if we're in ARRIVED_PICKUP mode BEFORE doing anything
    bool isMovedToClient = _isMovedToClientMode;

    if (!isMovedToClient) {
      currentLocation = null;
      currentToPickupPolyline.clear();
    }

    await setCustomMarkerIcon();
    // Update markers immediately after icons are loaded (even without polylines)
    _updateMarkersAndPolylines();

    try {
      await _loadPolylines();
    } catch (e) {
      _showSnackBar("Error loading route: $e", isError: true);
    }
  }

  Future<void> setCustomMarkerIcon() async {
    try {
      sourceIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2, size: Size(48, 48)),
          ImageAssets.locationPin);

      destinationIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2, size: Size(48, 48)),
          ImageAssets.locationPin);

      currentLocationIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2, size: Size(48, 48)),
          ImageAssets.driverCar);
    } catch (e) {
      print("❌ Error loading marker icons: $e");
    }
  }

  Future<void> _loadPolylines() async {
    if (!mounted) return;

    try {
      PolylinePoints polylinePoints = PolylinePoints();
      bool isMovedToClient = _isMovedToClientMode;

      // CRITICAL: In ARRIVED_PICKUP mode, NEVER fetch current location
      if (!isMovedToClient) {
        // Force clear currentLocation - should never be set in this mode
        currentLocation = null;
        currentToPickupPolyline.clear();
      }

      if (isMovedToClient) {
        // MODE: MOVED_TO_CLIENT - Show Current Location → Pickup

        // Clear destination polyline
        pickupToDestinationPolyline.clear();

        // Get current location
        try {
          currentLocation = await mapsRepo.getUserCurrentLocation();

          if (currentLocation == null) {
            _showSnackBar("Failed to get current location", isError: true);
            _updateMarkersAndPolylines();
            return;
          }

          // Update markers immediately after getting current location (before polyline)
          _updateMarkersAndPolylines();
          _showSnackBar("Loading route from current location to pickup...");

          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            googleApiKey: Platform.isIOS
                ? Constants.googleApiKeyIos
                : Constants.googleApiKeyAndroid,
            request: PolylineRequest(
              origin: PointLatLng(
                currentLocation!.latitude,
                currentLocation!.longitude,
              ),
              destination: PointLatLng(
                widget.tripModel.tripDetails.pickupLocation.latitude!,
                widget.tripModel.tripDetails.pickupLocation.longitude!,
              ),
              mode: TravelMode.driving,
            ),
          );

          // Check API response
          String statusMsg = (result.status ?? "unknown").toLowerCase().trim();
          bool hasPoints = result.points.isNotEmpty;
          String? errorMsg = result.errorMessage;

          if (statusMsg == "ok" && hasPoints && mounted) {
            currentToPickupPolyline = result.points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            _showSnackBar(
                "Route loaded: ${currentToPickupPolyline.length} points");
            _updateMarkersAndPolylines();
            // Wait a bit for map to render, then update camera
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) {
                _updateCameraBounds();
              }
            });
          } else {
            // Handle different error cases
            String displayMsg;
            if (statusMsg == "ok" && !hasPoints) {
              displayMsg = "No route found between locations";
            } else if (statusMsg == "REQUEST_DENIED" ||
                (errorMsg?.contains("REQUEST_DENIED") ?? false)) {
              displayMsg =
                  "API Key Error: Enable Directions API in Google Cloud Console";
            } else if (errorMsg != null && errorMsg.isNotEmpty) {
              displayMsg = "API Error ($statusMsg): $errorMsg";
            } else {
              displayMsg = "API Error ($statusMsg): Unable to get route";
            }

            _showSnackBar(displayMsg, isError: true);
            _updateMarkersAndPolylines();
            _updateCameraBounds();
          }
        } catch (e) {
          String errorStr = e.toString();
          String displayMsg;
          if (errorStr.contains("REQUEST_DENIED") ||
              errorStr.contains("REQUEST_DENIED")) {
            displayMsg =
                "API Key Error: Enable Directions API in Google Cloud Console";
          } else {
            displayMsg = "Error loading route: $e";
          }
          _showSnackBar(displayMsg, isError: true);
        }
      } else {
        // MODE: ARRIVED_PICKUP - Show Pickup → Destination
        try {
          // Clear current location and current-to-pickup polyline
          currentLocation = null;
          currentToPickupPolyline.clear();

          // Update markers immediately (pickup + destination, no current location)
          _updateMarkersAndPolylines();
          _showSnackBar("Loading route from pickup to destination...");

          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            googleApiKey: Platform.isIOS
                ? Constants.googleApiKeyIos
                : Constants.googleApiKeyAndroid,
            request: PolylineRequest(
              origin: PointLatLng(
                widget.tripModel.tripDetails.pickupLocation.latitude!,
                widget.tripModel.tripDetails.pickupLocation.longitude!,
              ),
              destination: PointLatLng(
                widget.tripModel.tripDetails.destinationLocation.latitude!,
                widget.tripModel.tripDetails.destinationLocation.longitude!,
              ),
              mode: TravelMode.driving,
            ),
          );

          // Check API response
          String statusMsg = (result.status ?? "unknown").toLowerCase().trim();
          bool hasPoints = result.points.isNotEmpty;
          String? errorMsg = result.errorMessage;

          if (statusMsg == "ok" && hasPoints && mounted) {
            pickupToDestinationPolyline = result.points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            _showSnackBar(
                "Route loaded: ${pickupToDestinationPolyline.length} points");
            // CRITICAL: Ensure currentLocation is null before updating
            currentLocation = null;
            _updateMarkersAndPolylines();
            // Wait a bit for map to render, then update camera
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) {
                _updateCameraBounds();
              }
            });
          } else {
            // Handle different error cases
            String displayMsg;
            if (statusMsg == "ok" && !hasPoints) {
              displayMsg = "No route found between locations";
            } else if (statusMsg == "REQUEST_DENIED" ||
                (errorMsg?.contains("REQUEST_DENIED") ?? false)) {
              displayMsg =
                  "API Key Error: Enable Directions API in Google Cloud Console";
            } else if (errorMsg != null && errorMsg.isNotEmpty) {
              displayMsg = "API Error ($statusMsg): $errorMsg";
            } else {
              displayMsg = "API Error ($statusMsg): Unable to get route";
            }

            _showSnackBar(displayMsg, isError: true);
            currentLocation = null;
            _updateMarkersAndPolylines();
            _updateCameraBounds();
          }
        } catch (e) {
          String errorStr = e.toString();
          String displayMsg;
          if (errorStr.contains("REQUEST_DENIED") ||
              errorStr.contains("REQUEST_DENIED")) {
            displayMsg =
                "API Key Error: Enable Directions API in Google Cloud Console";
          } else {
            displayMsg = "Error loading route: $e";
          }
          _showSnackBar(displayMsg, isError: true);
        }
      }
    } catch (e) {
      String errorStr = e.toString();
      String displayMsg;
      if (errorStr.contains("REQUEST_DENIED") ||
          errorStr.contains("REQUEST_DENIED")) {
        displayMsg =
            "API Key Error: Enable Directions API in Google Cloud Console";
      } else {
        displayMsg = "Fatal error loading route: $e";
      }
      _showSnackBar(displayMsg, isError: true);
    }
  }

  void _updateMarkersAndPolylines() {
    if (!mounted) return;

    // CRITICAL: Ensure currentLocation is cleared in ARRIVED_PICKUP mode BEFORE building markers
    bool isMovedToClient = _isMovedToClientMode;
    if (!isMovedToClient) {
      if (currentLocation != null) {
        currentLocation = null;
      }
      currentToPickupPolyline.clear();
    }

    // Build fresh markers and polylines
    _markers = _buildMarkers();
    _polylines = _buildPolylines();

    // SAFETY CHECK: In ARRIVED_PICKUP mode, explicitly remove any currentLocation marker
    if (!isMovedToClient) {
      int beforeCount = _markers.length;
      _markers
          .removeWhere((marker) => marker.markerId.value == "currentLocation");
      int afterCount = _markers.length;
      if (beforeCount != afterCount) {
        print(
            "⚠️ Removed currentLocation marker (ARRIVED_PICKUP mode) - ${beforeCount} -> ${afterCount}");
      }
      // Double-check: currentLocation should be null
      if (currentLocation != null) {
        print(
            "❌ ERROR: currentLocation is NOT null after removal! Force clearing...");
        currentLocation = null;
        // Rebuild markers one more time
        _markers = _buildMarkers();
        _markers.removeWhere(
            (marker) => marker.markerId.value == "currentLocation");
      }
    }

    setState(() {}); // Trigger rebuild

    // Update camera bounds after markers/polylines are updated
    if (mapController != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _updateCameraBounds();
        }
      });
    }
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};
    bool isMovedToClient = _isMovedToClientMode;

    print(
        "🔍 [MARKERS] Mode:${isMovedToClient ? 'MOVED_TO_CLIENT' : 'ARRIVED_PICKUP'} Step:${widget.currentStepIndex} CurrentLoc:${currentLocation != null}");

    // ALWAYS add pickup marker first
    if (widget.tripModel.tripDetails.pickupLocation.latitude != null &&
        widget.tripModel.tripDetails.pickupLocation.longitude != null) {
      Marker pickupMarker = Marker(
        markerId: MarkerId("pickup"),
        icon: sourceIcon,
        position: LatLng(
          widget.tripModel.tripDetails.pickupLocation.latitude!,
          widget.tripModel.tripDetails.pickupLocation.longitude!,
        ),
      );
      markers.add(pickupMarker);
      print("  ✅ Added pickup marker");
    }

    if (isMovedToClient) {
      // MOVED_TO_CLIENT mode: MUST show current location marker + pickup
      // DO NOT show destination marker
      if (currentLocation != null) {
        Marker currentLocMarker = Marker(
          markerId: MarkerId("currentLocation"),
          icon: currentLocationIcon,
          position: LatLng(
            currentLocation!.latitude,
            currentLocation!.longitude,
          ),
        );
        markers.add(currentLocMarker);
        print("  ✅ Added currentLocation marker");
      } else {
        print("  ⚠️ currentLocation is null in MOVED_TO_CLIENT mode");
      }
    } else {
      // ARRIVED_PICKUP mode: MUST show destination marker + pickup
      // ABSOLUTELY DO NOT show current location marker - even if currentLocation is set
      print("  🚫 ARRIVED_PICKUP mode - currentLocation marker is FORBIDDEN");

      // Force clear currentLocation one more time
      currentLocation = null;

      if (widget.tripModel.tripDetails.destinationLocation.latitude != null &&
          widget.tripModel.tripDetails.destinationLocation.longitude != null) {
        Marker destinationMarker = Marker(
          markerId: MarkerId("destination"),
          icon: destinationIcon,
          position: LatLng(
            widget.tripModel.tripDetails.destinationLocation.latitude!,
            widget.tripModel.tripDetails.destinationLocation.longitude!,
          ),
        );
        markers.add(destinationMarker);
        print("  ✅ Added destination marker");
      }
    }

    print(
        "  📊 Total markers: ${markers.length} - IDs: ${markers.map((m) => m.markerId.value).join(', ')}");
    return markers;
  }

  Set<Polyline> _buildPolylines() {
    Set<Polyline> polylines = {};
    bool isMovedToClient = _isMovedToClientMode;

    if (isMovedToClient) {
      // MOVED_TO_CLIENT mode: Show current → pickup polyline only
      // DO NOT show pickup to destination polyline
      // CRITICAL: Clear pickup to destination polyline
      pickupToDestinationPolyline.clear();

      if (currentToPickupPolyline.isNotEmpty) {
        // Validate points before adding
        if (currentToPickupPolyline.length >= 2) {
          polylines.add(
            Polyline(
              polylineId: PolylineId("currentToPickup"),
              points: currentToPickupPolyline,
              color: Colors.blue, // Using blue for better visibility
              width: 8, // Increased width
              geodesic: true,
              patterns: [],
            ),
          );
        } else {
          _showSnackBar("Invalid route: less than 2 points", isError: true);
        }
      }
    } else {
      // ARRIVED_PICKUP mode: Show pickup → destination polyline only
      // DO NOT show current to pickup polyline
      // CRITICAL: Clear current to pickup polyline and ensure currentLocation is null
      currentToPickupPolyline.clear();
      currentLocation = null;

      if (pickupToDestinationPolyline.isNotEmpty) {
        // Validate points before adding
        if (pickupToDestinationPolyline.length >= 2) {
          polylines.add(
            Polyline(
              polylineId: PolylineId("pickupToDestination"),
              points: pickupToDestinationPolyline,
              color: Colors.blue, // Using blue for better visibility
              width: 8, // Increased width
              geodesic: true,
              patterns: [],
            ),
          );
          print(
              "✅ [POLYLINE] Added pickupToDestination polyline (${pickupToDestinationPolyline.length} points)");
          print("   First point: ${pickupToDestinationPolyline.first}");
          print("   Last point: ${pickupToDestinationPolyline.last}");
        } else {
          print(
              "❌ [POLYLINE] pickupToDestinationPolyline has less than 2 points (${pickupToDestinationPolyline.length})");
        }
      } else {
        print(
            "⚠️ [POLYLINE] pickupToDestinationPolyline is empty in ARRIVED_PICKUP mode");
      }
    }

    print("📊 [POLYLINE] Total polylines built: ${polylines.length}");
    if (polylines.isNotEmpty) {
      polylines.forEach((poly) {
        print(
            "   Polyline ID: ${poly.polylineId.value}, Points: ${poly.points.length}");
      });
    }
    return polylines;
  }

  LatLngBounds _calculateBounds() {
    List<LatLng> points = [];
    bool isMovedToClient = _isMovedToClientMode;

    // Add marker points
    if (isMovedToClient && currentLocation != null) {
      // MOVED_TO_CLIENT: Current location + Pickup
      points.add(LatLng(currentLocation!.latitude, currentLocation!.longitude));
      points.add(LatLng(
        widget.tripModel.tripDetails.pickupLocation.latitude!,
        widget.tripModel.tripDetails.pickupLocation.longitude!,
      ));

      // Add polyline points for better bounds calculation
      if (currentToPickupPolyline.isNotEmpty) {
        // Add first, middle, and last points of polyline
        points.add(currentToPickupPolyline.first);
        if (currentToPickupPolyline.length > 2) {
          points.add(
              currentToPickupPolyline[currentToPickupPolyline.length ~/ 2]);
        }
        points.add(currentToPickupPolyline.last);
      }
    } else {
      // ARRIVED_PICKUP: Pickup + Destination
      points.add(LatLng(
        widget.tripModel.tripDetails.pickupLocation.latitude!,
        widget.tripModel.tripDetails.pickupLocation.longitude!,
      ));
      if (widget.tripModel.tripDetails.destinationLocation.latitude != null &&
          widget.tripModel.tripDetails.destinationLocation.longitude != null) {
        points.add(LatLng(
          widget.tripModel.tripDetails.destinationLocation.latitude!,
          widget.tripModel.tripDetails.destinationLocation.longitude!,
        ));
      }

      // Add polyline points for better bounds calculation
      if (pickupToDestinationPolyline.isNotEmpty) {
        // Add first, middle, and last points of polyline
        points.add(pickupToDestinationPolyline.first);
        if (pickupToDestinationPolyline.length > 2) {
          points.add(pickupToDestinationPolyline[
              pickupToDestinationPolyline.length ~/ 2]);
        }
        points.add(pickupToDestinationPolyline.last);
      }
    }

    if (points.isEmpty) {
      // Fallback to pickup location only
      points.add(LatLng(
        widget.tripModel.tripDetails.pickupLocation.latitude!,
        widget.tripModel.tripDetails.pickupLocation.longitude!,
      ));
    }

    if (points.length == 1) {
      // If only one point, create a small bounds around it
      double lat = points[0].latitude;
      double lng = points[0].longitude;
      return LatLngBounds(
        northeast: LatLng(lat + 0.01, lng + 0.01),
        southwest: LatLng(lat - 0.01, lng - 0.01),
      );
    }

    double north =
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double south =
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double east =
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);
    double west =
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);

    // Ensure minimum bounds size (but not too large)
    double latDiff = north - south;
    double lngDiff = east - west;

    // If bounds are too small, add a small padding
    if (latDiff < 0.01) {
      double padding = 0.005;
      north += padding;
      south -= padding;
    }
    if (lngDiff < 0.01) {
      double padding = 0.005;
      east += padding;
      west -= padding;
    }

    // Limit maximum bounds to prevent excessive zoom out
    // If the distance is too large, use a reasonable zoom level instead
    if (latDiff > 10.0 || lngDiff > 10.0) {
      // If locations are very far apart, center on midpoint with reasonable zoom
      double centerLat = (north + south) / 2;
      double centerLng = (east + west) / 2;
      // Create a smaller bounds around the center
      return LatLngBounds(
        northeast: LatLng(centerLat + 0.5, centerLng + 0.5),
        southwest: LatLng(centerLat - 0.5, centerLng - 0.5),
      );
    }

    return LatLngBounds(
      northeast: LatLng(north, east),
      southwest: LatLng(south, west),
    );
  }

  void _zoomToMarker1() {
    if (mapController == null || !mounted) return;
    bool isMovedToClient = _isMovedToClientMode;

    LatLng target;
    if (isMovedToClient && currentLocation != null) {
      // Marker 1: Current Location
      target = LatLng(currentLocation!.latitude, currentLocation!.longitude);
    } else {
      // Marker 1: Pickup Location
      target = LatLng(
        widget.tripModel.tripDetails.pickupLocation.latitude!,
        widget.tripModel.tripDetails.pickupLocation.longitude!,
      );
    }

    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(target, 16.0),
    );
  }

  void _zoomToMarker2() {
    if (mapController == null || !mounted) return;
    bool isMovedToClient = _isMovedToClientMode;

    LatLng target;
    if (isMovedToClient) {
      // Marker 2: Pickup Location
      target = LatLng(
        widget.tripModel.tripDetails.pickupLocation.latitude!,
        widget.tripModel.tripDetails.pickupLocation.longitude!,
      );
    } else {
      // Marker 2: Destination Location
      target = LatLng(
        widget.tripModel.tripDetails.destinationLocation.latitude!,
        widget.tripModel.tripDetails.destinationLocation.longitude!,
      );
    }

    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(target, 16.0),
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _toggleLocationTiles() {
    setState(() {
      _showLocationTiles = !_showLocationTiles;
    });
  }

  void _updateCameraBounds() {
    if (mapController == null || !mounted) return;

    try {
      final bounds = _calculateBounds();

      // Calculate padding based on screen size for better fit
      double padding =
          MediaQuery.of(context).size.width * 0.1; // 10% of screen width
      padding = padding.clamp(80.0, 200.0); // Min 80, Max 200 pixels

      // Use animateCamera with dynamic padding to fit both markers nicely
      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, padding),
      );
    } catch (e) {
      print("❌ Bounds error: $e");
      // Fallback: center between pickup and destination
      try {
        LatLng center = LatLng(
          (widget.tripModel.tripDetails.pickupLocation.latitude! +
                  widget.tripModel.tripDetails.destinationLocation.latitude!) /
              2,
          (widget.tripModel.tripDetails.pickupLocation.longitude! +
                  widget.tripModel.tripDetails.destinationLocation.longitude!) /
              2,
        );
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(center, 13.5),
        );
      } catch (e2) {
        print("❌ Fallback camera error: $e2");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMovedToClient = _isMovedToClientMode;

    // If markers/polylines are empty, build them now (initial build before async operations complete)
    if (_markers.isEmpty && _polylines.isEmpty) {
      _updateMarkersAndPolylines();
    }

    LatLng initialPosition = isMovedToClient && currentLocation != null
        ? LatLng(
            (currentLocation!.latitude +
                    widget.tripModel.tripDetails.pickupLocation.latitude!) /
                2,
            (currentLocation!.longitude +
                    widget.tripModel.tripDetails.pickupLocation.longitude!) /
                2,
          )
        : LatLng(
            widget.tripModel.tripDetails.pickupLocation.latitude!,
            widget.tripModel.tripDetails.pickupLocation.longitude!,
          );

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            key: ValueKey(
                'map_${widget.currentStepIndex}_${isMovedToClient}_${currentLocation == null ? 'noLoc' : 'hasLoc'}_${_markers.length}'),
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 13.5,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) async {
              this.mapController = controller;
              if (!this.controller.isCompleted) {
                this.controller.complete(controller);
              }

              // Wait a bit for markers/polylines to be ready, then update camera
              await Future.delayed(Duration(milliseconds: 500));
              if (mounted) {
                _updateCameraBounds();
              }
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapType: _currentMapType,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: true,
          ),
        ),
        // Bottom row of map controls - Positioned above profile card
        Positioned(
          bottom: 100, // Moved up to be above the profile card
          left: 12,
          right: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Zoom to Marker 1
                _buildBottomButton(
                  icon: isMovedToClient ? Icons.navigation : Icons.location_on,
                  label: isMovedToClient ? "Current" : "Pickup",
                  color: Colors.green,
                  onTap: _zoomToMarker1,
                ),
                // Zoom to Marker 2
                _buildBottomButton(
                  icon: isMovedToClient ? Icons.location_on : Icons.place,
                  label: isMovedToClient ? "Pickup" : "Dest",
                  color: Colors.red,
                  onTap: _zoomToMarker2,
                ),
                // Fit bounds
                _buildBottomButton(
                  icon: Icons.fit_screen,
                  label: "Fit All",
                  color: Colors.blue,
                  onTap: _updateCameraBounds,
                ),
                // Zoom in
                _buildBottomButton(
                  icon: Icons.add,
                  label: "Zoom +",
                  color: Colors.white,
                  textColor: Colors.black87,
                  onTap: () {
                    mapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                ),
                // Zoom out
                _buildBottomButton(
                  icon: Icons.remove,
                  label: "Zoom -",
                  color: Colors.white,
                  textColor: Colors.black87,
                  onTap: () {
                    mapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
                // Map type
                _buildBottomButton(
                  icon: _currentMapType == MapType.satellite
                      ? Icons.map
                      : Icons.satellite,
                  label:
                      _currentMapType == MapType.satellite ? "Normal" : "Sat",
                  color: _currentMapType == MapType.satellite
                      ? Colors.orange
                      : Colors.white,
                  textColor: _currentMapType == MapType.satellite
                      ? Colors.white
                      : Colors.black87,
                  onTap: _toggleMapType,
                ),
                // Toggle info
                _buildBottomButton(
                  icon: _showLocationTiles ? Icons.info : Icons.info_outline,
                  label: "Info",
                  color: _showLocationTiles ? Colors.purple : Colors.grey[600]!,
                  onTap: _toggleLocationTiles,
                ),
              ],
            ),
          ),
        ),
        // Location info tiles - Compact horizontal layout
        if (_showLocationTiles)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              children: [
                // First location tile - Compact
                Expanded(
                  child: _buildLocationTile(
                    context,
                    title: isMovedToClient ? "Current Location" : "Pickup",
                    subtitle: isMovedToClient && currentLocation != null
                        ? "${currentLocation!.latitude.toStringAsFixed(4)}, ${currentLocation!.longitude.toStringAsFixed(4)}"
                        : _getShortLocationName(widget.tripModel.tripDetails
                                .pickupLocation.locationName) ??
                            "${widget.tripModel.tripDetails.pickupLocation.latitude?.toStringAsFixed(4)}, ${widget.tripModel.tripDetails.pickupLocation.longitude?.toStringAsFixed(4)}",
                    icon:
                        isMovedToClient ? Icons.navigation : Icons.location_on,
                    color: isMovedToClient ? Colors.blue : Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                // Second location tile - Compact
                Expanded(
                  child: _buildLocationTile(
                    context,
                    title: isMovedToClient ? "Pickup" : "Destination",
                    subtitle: isMovedToClient
                        ? _getShortLocationName(widget.tripModel.tripDetails
                                .pickupLocation.locationName) ??
                            "${widget.tripModel.tripDetails.pickupLocation.latitude?.toStringAsFixed(4)}, ${widget.tripModel.tripDetails.pickupLocation.longitude?.toStringAsFixed(4)}"
                        : _getShortLocationName(widget.tripModel.tripDetails
                                .destinationLocation.locationName) ??
                            "${widget.tripModel.tripDetails.destinationLocation.latitude?.toStringAsFixed(4)}, ${widget.tripModel.tripDetails.destinationLocation.longitude?.toStringAsFixed(4)}",
                    icon: isMovedToClient ? Icons.location_on : Icons.place,
                    color: isMovedToClient ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String? _getShortLocationName(String? locationName) {
    if (locationName == null || locationName.isEmpty) return null;
    // Take first 25 characters or until first comma
    String short = locationName.length > 25
        ? locationName.substring(0, 25) + '...'
        : locationName;
    return short;
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: textColor ?? Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

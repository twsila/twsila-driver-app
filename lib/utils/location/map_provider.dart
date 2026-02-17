import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/utils/location/show_all_markers.dart';

import '../../presentation/google_maps/model/location_model.dart';

class MapProvider with ChangeNotifier {
  GoogleMapController? controller;
  MarkerId sourceMarkerId = const MarkerId('source_location');
  MarkerId destinationMarkerId = const MarkerId('destination_location');

  //Locations
  LocationModel? currentLocation;
  List<String> countries = ['eg'];
  String? distance;

  //Marker
  final Set<Marker> markers = {};

  //PolyLines
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  //Handle Markers
  addMarker(Marker marker) {
    markers.add(marker);
    notifyListeners();
  }

  removeMarker(MarkerId markerId) {
    markers.removeWhere((element) => element.markerId == markerId);
    notifyListeners();
  }

  setCountry(String country, {bool needsRebuild = true}) {
    countries = [country];
    if (!needsRebuild) return;
    notifyListeners();
  }

  //Handle Map
  animateCamera(LatLng latLng) async {
    if (controller == null) return;
    controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: latLng,
      zoom: 16.5,
    )));
  }

  setLocation(
      {LocationModel? sourceLocation, LocationModel? destinationLocation}) {
    if (sourceLocation == null && destinationLocation == null) {
      LatLng latLng =
          LatLng(currentLocation!.latitude, currentLocation!.longitude);
      removeMarker(sourceMarkerId);
      resetPolyPoints();
      addMarker(Marker(markerId: sourceMarkerId, position: latLng));
      animateCamera(latLng);
      return;
    } else if (sourceLocation != null && destinationLocation == null) {
      LatLng latLng = LatLng(sourceLocation.latitude, sourceLocation.longitude);
      removeMarker(destinationMarkerId);
      resetPolyPoints();
      addMarker(Marker(markerId: sourceMarkerId, position: latLng));
      animateCamera(latLng);
      return;
    } else if (sourceLocation == null && destinationLocation != null) {
      LatLng latLng =
          LatLng(destinationLocation.latitude, destinationLocation.longitude);
      removeMarker(sourceMarkerId);
      resetPolyPoints();
      addMarker(Marker(markerId: destinationMarkerId, position: latLng));
      animateCamera(latLng);
      return;
    }
    LatLng sourcePosition =
        LatLng(sourceLocation!.latitude, sourceLocation.longitude);
    LatLng destinationPosition =
        LatLng(destinationLocation!.latitude, destinationLocation.longitude);
    addMarker(
      Marker(markerId: sourceMarkerId, position: sourcePosition),
    );
    addMarker(
      Marker(markerId: destinationMarkerId, position: destinationPosition),
    );
    getPolyline(
        sourceLocation: sourceLocation,
        destinationLocation: destinationLocation);
  }

  //Handle Polylines
  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 2,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  getPolyline(
      {LocationModel? sourceLocation,
      LocationModel? destinationLocation}) async {
    if (controller == null ||
        sourceLocation == null ||
        destinationLocation == null) return;
    resetPolyPoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Platform.isIOS
            ? Constants.GOOGLE_API_KEY_IOS
            : Constants.GOOGLE_API_KEY_ANDROID,
        request: PolylineRequest(
            origin:
                PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
            destination: PointLatLng(
                destinationLocation.latitude, destinationLocation.longitude),
            mode: TravelMode.driving));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
    Future.delayed(
        const Duration(milliseconds: 200),
        () => controller!.animateCamera(CameraUpdate.newLatLngBounds(
            MapUtils.boundsFromLatLngList(
                markers.map((loc) => loc.position).toList()),
            1)));

    calculateDistance(polylineCoordinates);
  }

  resetPolyPoints() {
    polylineCoordinates.clear();
    polylines.clear();
    distance = null;
    notifyListeners();
  }

  calculateDistance(List<LatLng> polylineCoordinates) {
    double totalDistance = 0.0;
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }
    distance = '${totalDistance.toStringAsFixed(2)} km';
    notifyListeners();
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

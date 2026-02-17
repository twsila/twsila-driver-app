import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/location/map_provider.dart';
import '../model/location_model.dart';

class GoogleMapsWidget extends StatefulWidget {
  LocationModel? sourceLocation;
  LocationModel? destinationLocation;
  GoogleMapsWidget(
      {Key? key,
      required this.sourceLocation,
      required this.destinationLocation})
      : super(key: key);

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  bool _isInit = true;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition position = const CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 16.5,
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;

      setMapController();
    }
    super.didChangeDependencies();
  }

  setMapController() async {
    Provider.of<MapProvider>(context, listen: false).controller =
        await _controller.future;
    LocationModel? currentLocation =
        Provider.of<MapProvider>(context, listen: false).currentLocation;
    if (widget.sourceLocation == null) {
      Provider.of<MapProvider>(context, listen: false)
          .setLocation(sourceLocation: currentLocation);
    } else {
      Provider.of<MapProvider>(context, listen: false).setLocation(
        sourceLocation: widget.sourceLocation,
        destinationLocation: widget.destinationLocation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context, mapProvider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: position,
              markers: Set.from(mapProvider.markers),
              polylines: Set<Polyline>.of(mapProvider.polylines.values),
            ),
          ),
          const SizedBox(height: 8),
          if (mapProvider.distance != null)
            Text('Distance: ${mapProvider.distance}'),
        ],
      );
    });
  }
}

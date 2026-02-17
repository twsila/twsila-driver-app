import 'package:geolocator/geolocator.dart';

import '../../presentation/google_maps/model/location_model.dart';

class UserCurrentLocation {
  Future<LocationModel> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position currentLocation = await Geolocator.getCurrentPosition();

    // final coordinates =
    //     Coordinates(currentLocation.latitude, currentLocation.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    // print(
    //     ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    LocationModel locationModel = LocationModel(
      locationName: "",
      // locationName: first.addressLine!,
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );
    return locationModel;
  }
}

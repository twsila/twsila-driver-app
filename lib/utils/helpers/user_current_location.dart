import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_geocoder/location_geocoder.dart';
import '../../../app/constants.dart';
import '../../presentation/google_maps/model/location_model.dart';
import '../resources/strings_manager.dart';

class UserCurrentLocation {
  final LocatitonGeocoder geocoder = LocatitonGeocoder(Platform.isIOS
      ? Constants.GOOGLE_API_KEY_IOS
      : Constants.GOOGLE_API_KEY_ANDROID);

  Future checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw PlatformException(
          code: "", message: AppStrings.locationDisabled.tr());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PlatformException(
            code: "", message: AppStrings.locationDenied.tr());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PlatformException(
          code: "", message: AppStrings.locationDeniedLong.tr());
    }
  }

  Future<LocationModel> getCurrentLocation() async {
    await checkLocationPermission();
    Position currentLocation = await Geolocator.getCurrentPosition();

    // final coordinates =
    //     Coordinates(currentLocation.latitude, currentLocation.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    // print(
    //     ' ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    LocationModel locationModel = LocationModel(
      // locationName: first.addressLine!,
      locationName: "",
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );
    return locationModel;
  }
}

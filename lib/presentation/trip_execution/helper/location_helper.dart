import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../domain/model/distance_matrix_model.dart';

class LocationHelper {
  final LocatitonGeocoder geocoder = LocatitonGeocoder(Platform.isIOS
      ? Constants.GOOGLE_API_KEY_IOS
      : Constants.GOOGLE_API_KEY_ANDROID);

  double distanceBetweenTwoLocationInMeters(
      {required double lat1,
      required double long1,
      required double lat2,
      required double long2}) {
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, long1, lat2, long2);
    return distanceInMeters;
  }

  Future<String> getArrivalTimeFromCurrentToLocation(
      {required LocationModel currentLocation,
      required LocationModel destinationLocation}) async {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    String resultStringData = '';
    Dio dio = new Dio();
    var matrixUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${destinationLocation.latitude},${destinationLocation.longitude}&language=${_appPrefs.getAppLanguage()}&origins=${currentLocation.latitude},${currentLocation.longitude}&key=${Platform.isIOS ? Constants.GOOGLE_API_KEY_IOS : Constants.GOOGLE_API_KEY_ANDROID}';
    try {
      var response = await dio.get(matrixUrl);
      final data = response.data;
      if (data is! Map<String, dynamic>) return '';
      DistanceMatrix matrix = DistanceMatrix.fromJson(data);
      final durationText = matrix.elements?.isNotEmpty == true
          ? matrix.elements!.first.duration?.text
          : null;
      resultStringData = durationText ?? '';
    } catch (_) {
      resultStringData = '';
    }
    return resultStringData.isNotEmpty
        ? "${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} $resultStringData"
        : '';
  }

  String getCityName(Prediction prediction) {
    List<Terms> newTerms = prediction.terms!;
    newTerms.removeLast();
    return newTerms.last.value.toString();
  }

  Future<String> getCityNameByCoordinates(double lat, double long) async {
    final coordinates = Coordinates(lat, long);
    var address = await geocoder.findAddressesFromCoordinates(coordinates);
    return address.length > 0
        ? address[0].locality ?? address[0].adminArea ?? ''
        : '';
  }
}

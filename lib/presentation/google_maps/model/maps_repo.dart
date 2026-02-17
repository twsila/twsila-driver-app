import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/location/user_current_location.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'location_model.dart';

class MapsRepo {
  Future<LocationModel> getUserCurrentLocation() async {
    try {
      LocationModel currentLocation =
          await UserCurrentLocation().getCurrentLocation();
      return currentLocation;
    } catch (error) {
      throw FlutterError(error.toString());
    }
  }

  static Future<void> openGoogleMapsWithCoordinates(
      {required BuildContext context,
      required double sLatitude,
      required double sLongitude,
      required double dLatitude,
      required double dLongitude}) async {
    String appleUrl =
        'https://maps.apple.com/?saddr=${sLatitude},${sLongitude}&daddr=${dLatitude},${dLongitude}&directionsmode=driving';
    String googleUrl =
        'http://maps.google.com/maps?saddr=${sLatitude},${sLongitude}&daddr=${dLatitude},${dLongitude}&directionsmode=driving';
    Uri appleUri = Uri.parse(appleUrl);
    Uri googleUri = Uri.parse(googleUrl);

    if (Platform.isIOS) {
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(googleUri)) {
          await launchUrl(googleUri, mode: LaunchMode.externalApplication);
        } else {
          ToastHandler(context)
              .showToast(AppStrings.cannotOpenMaps.tr(), Toast.LENGTH_LONG);
        }
      }
    } else {
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      } else {
        ToastHandler(context)
            .showToast(AppStrings.cannotOpenMaps.tr(), Toast.LENGTH_LONG);
      }
    }
  }
}

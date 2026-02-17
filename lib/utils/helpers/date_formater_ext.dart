import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:taxi_for_you/app/app_prefs.dart';

import '../../../app/di.dart';

extension DateString on BuildContext {
  String formatDateTime({
    String pattern = 'EEEE dd MMM yyyy / hh:mm a',
    DateTime? dateTime,
  }) {
    final AppPreferences _appPrefs = instance();


    return DateFormat(pattern, _appPrefs.getAppLanguage())
        .format(dateTime ?? DateTime.now());
  }

  String currentDateTimeString({String pattern = 'dd/MM/yyyy hh:mm a'}) {
    return DateFormat(pattern).format(DateTime.now());
  }

  DateTime currentDateTime() {
    return DateTime.now();
  }
}

extension DateFormatString on String {
  String formatStringToDateString() {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    return DateFormat('dd MMM yyyy/ hh:mm a', _appPrefs.getAppLanguage())
        .format(DateFormat('dd/MM/yyyy hh:mm:ss', _appPrefs.getAppLanguage())
        .parse(this));
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';

class MyProfileHelper {
  Future<void> changeAppLanguage(BuildContext context, String lang) async {
    final SharedPreferences _sharedPreferences = instance();
    _sharedPreferences.setString(PREFS_KEY_LANG, lang);
    // await Get.updateLocale(Locale(lang));
    Phoenix.rebirth(context);
  }

  // void setAppLanguage(String lang) {
  //   Get.updateLocale(Locale(lang));
  // }
}

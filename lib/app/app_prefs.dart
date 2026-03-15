import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/domain/model/allowed_services_model.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';
import 'package:taxi_for_you/domain/model/country_lookup_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../presentation/main/pages/myprofile/my_profile_helper.dart';
import '../utils/resources/assets_manager.dart';
import '../utils/resources/langauge_manager.dart';
import '../utils/resources/strings_manager.dart';

class PrefsKeys {
  static const String lang = "PREFS_KEY_LANG";
  static const String onboardingScreenViewed = "PREFS_KEY_ONBOARDING_SCREEN_VIEWED";
  static const String isUserLoggedIn = "PREFS_KEY_IS_USER_LOGGED_IN";
  static const String userSelectedCountry = "USER_SELECTED_COUNTRY";
  static const String driverModel = "DRIVER_MODEL";
  static const String coastCalculationData = "COAST_CALCULATION_DATA";
  static const String driverFcmToken = "DRIVER_FCM_TOKEN";
  static const String userType = "USER_TYPE";
  static const String currentCountryCode = "CURRENT_COUNTRY_CODE";
  static const String allowedServicesList = "ALLOWED_SERVICES_LIST_KEY";
}

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  List<CountryLookupModel> countries = [];

  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language = _sharedPreferences.getString(PrefsKeys.lang);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ARABIC.getValue();
    }
  }

  bool isEnglish() {
    return getAppLanguage() == LanguageType.ENGLISH.getValue();
  }

  Future<bool> setCoastCalculationData(
      CoastCalculationModel coastCalculation) async {
    String coastCalculationStr = json.encode(coastCalculation);
    await _sharedPreferences.setString(
        PrefsKeys.coastCalculationData, coastCalculationStr);
    return true;
  }

  Future<CoastCalculationModel> getCoastCalculationData() async {
    var coastStr = await jsonDecode(
        _sharedPreferences.getString(PrefsKeys.coastCalculationData)!);
    return CoastCalculationModel.fromJson(coastStr);
  }

  Future<void> changeAppLanguage(BuildContext context) async {
    String currentLang = getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      // set english
      MyProfileHelper()
          .changeAppLanguage(context, LanguageType.ENGLISH.getValue());
    } else {
      // set arabic
      MyProfileHelper()
          .changeAppLanguage(context, LanguageType.ARABIC.getValue());
    }

    Phoenix.rebirth(context);
  }

  Future<Locale> getLocal() async {
    String currentLang = getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      // MyProfileHelper().setAppLanguage(LanguageType.ARABIC.getValue());
      return ARABIC_LOCAL;
    } else {
      // MyProfileHelper().setAppLanguage(LanguageType.ENGLISH.getValue());
      return ENGLISH_LOCAL;
    }
  }

  Future<bool> setDriver(DriverBaseModel driver) async {
    await setUserLoggedIn();
    String driverStr = json.encode(driver);
    await _sharedPreferences.setString(PrefsKeys.driverModel, driverStr);
    return true;
  }

  Future<String> userProfilePicture(DriverBaseModel driverBaseModel,
      {String? userType}) async {
    String? imageUrl;
    if (driverBaseModel.captainType == RegistrationConstants.captain ||
        userType == RegistrationConstants.captain) {
      if ((driverBaseModel as Driver).images.isNotEmpty) {
        driverBaseModel.images.forEach((element) {
          if (element.imageName == DriverImagesConstants.DRIVER_PHOTO_IMAGE_STRING) {
            imageUrl = element.imageUrl.toString();
          }
        });
      }
      if (imageUrl == null) {
        imageUrl = driverBaseModel.images[0].imageUrl ?? '';
      }
    } else {
      if (driverBaseModel.captainType == RegistrationConstants.businessOwner ||
          userType == RegistrationConstants.businessOwner) {
        if ((driverBaseModel as BusinessOwnerModel).imagesFromApi != null &&
            driverBaseModel.imagesFromApi!.isNotEmpty) {
          driverBaseModel.imagesFromApi!.forEach((element) {
            if (element.imageName ==
                Constants.businessOwnerPhotoImageString) {
              imageUrl = element.imageUrl.toString();
            }
          });
        }
        if (driverBaseModel.imagesFromApi != null &&
            driverBaseModel.imagesFromApi!.isNotEmpty &&
            imageUrl == null) {
          imageUrl = driverBaseModel.imagesFromApi![0].imageUrl ?? '';
        } else if (driverBaseModel.imagesFromApi == null) {
          imageUrl = '';
        }
      }
    }
    return imageUrl!;
  }

  setUserSelectedCountry(String country) {
    _sharedPreferences.setString(PrefsKeys.userSelectedCountry, country);
  }

  String? getUserSelectedCountry() {
    return _sharedPreferences.getString(PrefsKeys.userSelectedCountry);
  }

  String? getUserType() {
    return _sharedPreferences.getString(PrefsKeys.userType);
  }

  setUserType(String userType) {
    return _sharedPreferences.setString(PrefsKeys.userType, userType);
  }

  Future setFCMToken(String token) async {
    await _sharedPreferences.setString(PrefsKeys.driverFcmToken, token);
  }

  Future<String?> getFCMToken() async {
    return _sharedPreferences.getString(PrefsKeys.driverFcmToken);
  }

  setCountries(List<CountryLookupModel> countries) {
    this.countries = countries;
  }

  saveAllowedServicesList(List<AllowedServiceModel> servicesList) async {
    List<String> servicesListJson = servicesList
        .map((AllowedServiceModel) => jsonEncode(AllowedServiceModel.toJson()))
        .toList();
    await _sharedPreferences.setStringList(
        PrefsKeys.allowedServicesList, servicesListJson);
  }

  Future<List<AllowedServiceModel>> getAllowedServicesList() async {
    List<String>? jsonStringList =
        _sharedPreferences.getStringList(PrefsKeys.allowedServicesList);

    if (jsonStringList != null) {
      return await jsonStringList
          .map((jsonString) =>
              AllowedServiceModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  List<CountryLookupModel> getCountries() {
    return countries.isNotEmpty
        ? countries
        : [
            CountryLookupModel(
              countryName: AppStrings.saudiArabia.tr(),
              country: "SA",
              countryCode: "+966",
              countryCodeAr: "+٩٦٦",
              imageUrl: ImageAssets.saudiFlag,
              countryId: 2,
              language: 'ar',
            ),
            CountryLookupModel(
              countryName: AppStrings.egypt.tr(),
              country: "EG",
              countryCode: "+20",
              countryCodeAr: "+٢٠",
              countryId: 4,
              imageUrl: ImageAssets.egyptFlag,
              language: 'ar',
            ),
          ];
  }

  setCurrentCountryCode(String countryCode) {}

  DriverBaseModel? getCachedDriver() {
    Map<String, dynamic> driverMap = {};
    if (_sharedPreferences.getString(PrefsKeys.driverModel) != null &&
        _sharedPreferences.getString(PrefsKeys.driverModel) != "") {
      driverMap = jsonDecode(_sharedPreferences.getString(PrefsKeys.driverModel)!);
      if (driverMap["userDevice"] != null) {
        driverMap["userDevice"] = UserDevice.fromJson(driverMap["userDevice"]);
      }
    }
    if (driverMap["captainType"] == RegistrationConstants.businessOwner) {
      return driverMap.length != 0
          ? BusinessOwnerModel.fromCachedJson(driverMap)
          : null;
    } else {
      return driverMap.length != 0 ? Driver.fromJson(driverMap) : null;
    }
  }

  Future<bool> setRefreshedToken(String newToken) async {
    DriverBaseModel? driver = getCachedDriver();
    if (driver != null) {
      driver.accessToken = newToken;
      await setDriver(driver);
      return true;
    } else {
      return false;
    }
  }

  bool? removeCachedDriver() {
    _sharedPreferences.setString(PrefsKeys.driverModel, "");
    return true;
  }

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(PrefsKeys.onboardingScreenViewed, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(PrefsKeys.onboardingScreenViewed) ??
        false;
  }

  Future<void> setOnboardingSeen(bool value) async {
    _sharedPreferences.setBool(PrefsKeys.onboardingScreenViewed, value);
  }

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PrefsKeys.isUserLoggedIn, true);
  }

  Future<void> setUserLoggedOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _sharedPreferences.setBool(PrefsKeys.isUserLoggedIn, false);
    Phoenix.rebirth(context);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PrefsKeys.isUserLoggedIn) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PrefsKeys.isUserLoggedIn);
  }
}

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

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED =
    "PREFS_KEY_ONBOARDING_SCREEN_VIEWED";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String USER_SELECTED_COUNTRY = "USER_SELECTED_COUNTRY";
const String DRIVER_MODEL = "DRIVER_MODEL";
const String COAST_CALCULATION_DATA = "COAST_CALCULATION_DATA";
const String DRIVER_FCM_TOKEN = "DRIVER_FCM_TOKEN";
const String USER_TYPE = "USER_TYPE";
const String CURRENT_COUNTRY_CODE = "CURRENT_COUNTRY_CODE";
const String ALLOWED_SERVICES_LIST_KEY = "ALLOWED_SERVICES_LIST_KEY";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  List<CountryLookupModel> countries = [];

  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ARABIC.getValue();
    }
  }

  bool isEnglish() {
    return getAppLanguage() == LanguageType.ENGLISH.getValue();
  }

  //set CoastCalculation Data
  Future<bool> setCoastCalculationData(
      CoastCalculationModel coastCalculation) async {
    String coastCalculationStr = json.encode(coastCalculation);
    await _sharedPreferences.setString(
        COAST_CALCULATION_DATA, coastCalculationStr);
    return true;
  }

  //get CoastCalculation Data
  Future<CoastCalculationModel> getCoastCalculationData() async {
    var coastStr =
        await jsonDecode(_sharedPreferences.getString(COAST_CALCULATION_DATA)!);
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

  //driver functionalities
  Future<bool> setDriver(DriverBaseModel driver) async {
    await setUserLoggedIn();
    String driverStr = json.encode(driver);
    await _sharedPreferences.setString(DRIVER_MODEL, driverStr);
    return true;
  }

  Future<String> userProfilePicture(DriverBaseModel driverBaseModel,
      {String? userType}) async {
    String? imageUrl;
    if (driverBaseModel.captainType == RegistrationConstants.captain ||
        userType == RegistrationConstants.captain) {
      if ((driverBaseModel as Driver).images.isNotEmpty) {
        driverBaseModel.images.forEach((element) {
          if (element.imageName == Constants.DRIVER_PHOTO_IMAGE_STRING) {
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
                Constants.BUSINESS_OWNER_PHOTO_IMAGE_STRING) {
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

  //Selected country
  setUserSelectedCountry(String country) {
    _sharedPreferences.setString(USER_SELECTED_COUNTRY, country);
  }

  String? getUserSelectedCountry() {
    return _sharedPreferences.getString(USER_SELECTED_COUNTRY);
  }

  String? getUserType() {
    return _sharedPreferences.getString(USER_TYPE);
  }

  setUserType(String userType) {
    return _sharedPreferences.setString(USER_TYPE, userType);
  }

  //USER Firebase Token
  Future setFCMToken(String token) async {
    await _sharedPreferences.setString(DRIVER_FCM_TOKEN, token);
  }

  Future<String?> getFCMToken() async {
    return _sharedPreferences.getString(DRIVER_FCM_TOKEN);
  }

  setCountries(List<CountryLookupModel> countries) {
    this.countries = countries;
  }

  saveAllowedServicesList(List<AllowedServiceModel> servicesList) async {
    List<String> servicesListJson = servicesList
        .map((AllowedServiceModel) => jsonEncode(AllowedServiceModel.toJson()))
        .toList();
    await _sharedPreferences.setStringList(
        ALLOWED_SERVICES_LIST_KEY, servicesListJson);
  }

  Future<List<AllowedServiceModel>> getAllowedServicesList() async {
    List<String>? jsonStringList =
        _sharedPreferences.getStringList(ALLOWED_SERVICES_LIST_KEY);

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
    if (_sharedPreferences.getString(DRIVER_MODEL) != null &&
        _sharedPreferences.getString(DRIVER_MODEL) != "") {
      driverMap = jsonDecode(_sharedPreferences.getString(DRIVER_MODEL)!);
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
    _sharedPreferences.setString(DRIVER_MODEL, "");
    return true;
  }

  // on boarding

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  Future<void> setOnboardingSeen(bool value) async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, value);
  }

  //login

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<void> setUserLoggedOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, false);
    Phoenix.rebirth(context);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }
}

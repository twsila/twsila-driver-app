import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/gender_model.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class RegisterBusinessOwnerViewModel {
  final TextEditingController mobileNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final formKey = GlobalKey<FormState>();
  bool displayLoadingIndicator = false;
  bool termsAndCondition = false;
  bool isValid = false;
  BusinessOwnerModel businessOwnerModel = BusinessOwnerModel();
  List<GenderModel> genderTypes = [
    GenderModel(value: 'M', name: AppStrings.male.tr()),
    GenderModel(value: 'F', name: AppStrings.female.tr()),
  ];

  bind(String mobile) {
    mobileNumberController.text = mobile;
    businessOwnerModel.mobile = mobile;
  }

  dispose() {
    mobileNumberController.dispose();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/gender_widget.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/terms_conditions.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/upload_bo_document.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/common/widgets/multi_pick_image.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/documents_helper.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../../utils/resources/font_manager.dart';
import '../../../../../utils/resources/styles_manager.dart';
import '../../../../service_registration/view/widgets/uploadDocumentWidget.dart';

class RegistartionBOInputFields extends StatefulWidget {
  final RegisterBusinessOwnerViewModel viewModel;

  const RegistartionBOInputFields({Key? key, required this.viewModel})
      : super(key: key);

  @override
  State<RegistartionBOInputFields> createState() =>
      _RegistartionBOInputFieldsState();
}

class _RegistartionBOInputFieldsState extends State<RegistartionBOInputFields> {
  String? nationalIdExpiryDate;
  String? dateOfBirth;
  String? commercialRegisterExpiryDate;

  // Default to 25 years ago as initial date
  DateTime get selectedBirthDate =>
      DateTime.now().subtract(Duration(days: 365 * 25));

  checkValidations() {
    setState(() {
      widget.viewModel.isValid = widget
                  .viewModel.formKey.currentState !=
              null &&
          widget.viewModel.formKey.currentState!.validate() &&
          widget.viewModel.businessOwnerModel.nationalIdExpiryDate != null &&
          widget
              .viewModel.businessOwnerModel.nationalIdExpiryDate!.isNotEmpty &&
          widget.viewModel.businessOwnerModel.dateOfBirth != null &&
          widget.viewModel.businessOwnerModel.dateOfBirth!.isNotEmpty &&
          widget.viewModel.businessOwnerModel.commercialRegisterExpiryDate !=
              null &&
          widget.viewModel.businessOwnerModel.commercialRegisterExpiryDate!
              .isNotEmpty &&
          widget.viewModel.termsAndCondition != false &&
          widget.viewModel.businessOwnerModel.images != null &&
          widget.viewModel.businessOwnerModel.images!.isNotEmpty &&
          widget.viewModel.businessOwnerModel.profileImage != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.ownerfirstName.tr(),
            showLabelText: true,
            validateSpecialCharacter: true,
            isCharacterOnly: true,
            hintText: AppStrings.enterFirstNameHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.firstName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.ownerlastName.tr(),
            showLabelText: true,
            validateSpecialCharacter: true,
            isCharacterOnly: true,
            hintText: AppStrings.enterLastNameHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.lastName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            controller: widget.viewModel.mobileNumberController,
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.mobileNumber.tr(),
            showLabelText: true,
            enabled: false,
            hintText: AppStrings.phoneNumberHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.entityName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          Container(
            child: Text(
              AppStrings.birtDate.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ColorManager.headersTextColor),
            ),
          ),
          CustomDateOfBirthWidget(),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.companyName.tr(),
            showLabelText: true,
            validateSpecialCharacter: true,
            isCharacterOnly: true,
            hintText: AppStrings.companyNameHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.entityName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.commercialNumber.tr(),
            showLabelText: true,
            keyboardType: TextInputType.number,
            hintText: AppStrings.commercialNumberHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.commercialNumber = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          Container(
            child: Text(
              AppStrings.commercialExpiryDate.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ColorManager.headersTextColor),
            ),
          ),
          const SizedBox(height: 8),
          CustomCommercialExpiryDateWidget(),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.taxNumber.tr(),
            showLabelText: true,
            keyboardType: TextInputType.number,
            hintText: AppStrings.commercialNumberHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.taxNumber = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.nationalID.tr(),
            showLabelText: true,
            keyboardType: TextInputType.number,
            hintText: AppStrings.nationalIDHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.nationalId = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          Container(
            child: Text(
              AppStrings.nationalIdExpiryDate.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ColorManager.headersTextColor),
            ),
          ),
          CustomNationalIdExpiryDateWidget(),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmail: true,
            validateEmptyString: true,
            labelText: AppStrings.email.tr(),
            showLabelText: true,
            hintText: AppStrings.emailHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.email = value;
              checkValidations();
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: GenderWidget(
              initialGender: widget.viewModel.businessOwnerModel.gender,
              viewModel: widget.viewModel,
              onSelectGender: (gender) {
                widget.viewModel.businessOwnerModel.gender = gender.value;
              },
            ),
          ),
          MutliPickImageWidget(
            (images) {
              if (images == null) return;
              widget.viewModel.businessOwnerModel.images =
                  images.map<File>((xfile) => File(xfile.path)).toList();
              checkValidations();
            },
            AppStrings.uploadBOid.tr(),
            AppStrings.boImage.tr(),
            Icon(Icons.person, color: Colors.white),
            ColorManager.headersTextColor,
            null,
            onRemovedImage: (removedImage) {
              widget.viewModel.businessOwnerModel.images!
                  .removeWhere((element) => element.path == removedImage.path);
              checkValidations();
            },
          ),
          TermsAndConditionsWidget(onChecked: (check) {
            widget.viewModel.termsAndCondition = check;
            checkValidations();
          }),
          Container(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(AppPadding.p8),
            color: Colors.white,
            child: CustomTextButton(
              onPressed: widget.viewModel.isValid
                  ? () {
                      BlocProvider.of<ServiceRegistrationBloc>(context).add(
                        RegisterBOWithService(
                          businessOwnerModel:
                              widget.viewModel.businessOwnerModel,
                        ),
                      );
                    }
                  : null,
              text: AppStrings.save.tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget UploadDocumentWidget(
      String title, String buttonText, Function() onTap) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getRegularStyle(
                color: ColorManager.titlesTextColor, fontSize: FontSize.s14),
          ),
          CustomTextButton(
            text: buttonText,
            width: AppSize.s140,
            height: AppSize.s50,
            isWaitToEnable: false,
            fontSize: FontSize.s10,
            backgroundColor: ColorManager.secondaryColor,
            onPressed: onTap,
          )
        ],
      ),
    );
  }

  Future<void> _selectNationalIdExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        nationalIdExpiryDate = picked.millisecondsSinceEpoch.toString();
        widget.viewModel.businessOwnerModel.nationalIdExpiryDate =
            nationalIdExpiryDate;
        checkValidations();
      });
    }
  }

  Widget CustomNationalIdExpiryDateWidget() {
    return GestureDetector(
      onTap: () {
        _selectNationalIdExpiryDate(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                nationalIdExpiryDate != null
                    ? nationalIdExpiryDate!
                        .getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.nationalIdExpiryDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: nationalIdExpiryDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime now = DateTime.now();
    // Calculate maximum date: today minus 18 years (must be at least 18 years old)
    final DateTime maxDate = DateTime(now.year - 18, now.month, now.day);
    // Use selected date if available, otherwise default to 25 years ago
    final DateTime initialDate = dateOfBirth != null
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(dateOfBirth!))
        : selectedBirthDate;

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate.isBefore(maxDate) ? initialDate : maxDate,
        firstDate: DateTime(1940, 1, 1),
        lastDate: maxDate,
        locale: Locale(
            'en', 'US'), // You can make this dynamic based on app language
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary:
                    ColorManager.primary, // Primary color for selected date
                onPrimary: Colors.white, // Text color on selected date
                surface: Colors.white, // Background color
                onSurface: ColorManager.headersTextColor, // Text color
                secondary:
                    ColorManager.primary.withOpacity(0.1), // Accent color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.primary, // Button text color
                ),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      // Validate age: must be at least 18 years old
      final DateTime today = DateTime.now();
      final int age = today.year - picked.year;
      final bool isAtLeast18 = age > 18 ||
          (age == 18 &&
              (today.month > picked.month ||
                  (today.month == picked.month && today.day >= picked.day)));

      if (!isAtLeast18) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You must be at least 18 years old to register.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Don't set the date if validation fails
      }

      setState(() {
        dateOfBirth = picked.millisecondsSinceEpoch.toString();
        widget.viewModel.businessOwnerModel.dateOfBirth = dateOfBirth;
        checkValidations();
      });
    }
  }

  Widget CustomDateOfBirthWidget() {
    return GestureDetector(
      onTap: () {
        _selectDateOfBirth(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                dateOfBirth != null
                    ? dateOfBirth!.getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.birtDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: dateOfBirth != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectCommercialExpiry(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        commercialRegisterExpiryDate = picked.millisecondsSinceEpoch.toString();
        widget.viewModel.businessOwnerModel.commercialRegisterExpiryDate =
            commercialRegisterExpiryDate;
        checkValidations();
      });
    }
  }

  Widget CustomCommercialExpiryDateWidget() {
    return GestureDetector(
      onTap: () {
        _selectCommercialExpiry(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                commercialRegisterExpiryDate != null
                    ? commercialRegisterExpiryDate!
                        .getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.commercialExpiryDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: nationalIdExpiryDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}

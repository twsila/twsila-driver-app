import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../common/state_renderer/dialogs.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

class CaptainRegistrationView extends StatefulWidget {
  final String mobileNumber;

  CaptainRegistrationView({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  State<CaptainRegistrationView> createState() =>
      _CaptainRegistrationViewState();
}

class _CaptainRegistrationViewState extends State<CaptainRegistrationView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  bool agreeWithTerms = false;
  bool isMale = false;
  bool isFemale = false;
  XFile? captainPhoto = XFile('');
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? birthDate;
  String? nationalIdNumber;
  String? nationalIdExpiryDate;
  Function()? continueFunction;
  ImagePicker imgpicker = ImagePicker();

  // Default to 25 years ago as initial date for birth date
  DateTime get _defaultBirthDate => birthDate != null
      ? DateTime.fromMillisecondsSinceEpoch(int.parse(birthDate!))
      : DateTime.now().subtract(Duration(days: 365 * 25));

  DateTime selectedDate = DateTime.now(); // Used for national ID expiry date

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<ServiceRegistrationBloc, ServiceRegistrationState>(
        listener: (context, state) {
      if (state is captainDataAddedState) {
        Navigator.pushNamed(context, Routes.serviceRegistrationFirstStep,
            arguments: ServiceRegistrationFirstStepArguments(
                state.registrationRequest));
      }
      if (state is CaptainDataIsValid) {
        continueFunction = () {
          bool validate = _formKey.currentState!.validate();
          if (validate) {
            BlocProvider.of<ServiceRegistrationBloc>(context).add(
                SetCaptainData(
                    captainPhoto!,
                    widget.mobileNumber,
                    firstName!,
                    lastName!,
                    email ?? "",
                    gender!,
                    birthDate!,
                    nationalIdNumber!,
                    nationalIdExpiryDate!));
          }
        };
      }
      if (state is CaptainDataIsNotValid) {
        continueFunction = null;
      }
    }, builder: (context, state) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: AppMargin.m20, vertical: AppMargin.m12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _headerText(),
                  const SizedBox(height: AppSize.s25),
                  _uploadCaptainPhoto(),
                  const SizedBox(height: AppSize.s28),
                  _inputFields(),
                  const SizedBox(height: AppSize.s20),
                  CustomTextButton(
                    onPressed:
                        continueFunction != null ? continueFunction : null,
                    text: AppStrings.continueStr.tr(),
                    borderRadius: BorderRadius.circular(12),
                    margin: 0,
                  ),
                  const SizedBox(height: AppSize.s25),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  openImages() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: ColorManager.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.photo_library_rounded,
                        color: ColorManager.primary, size: 24),
                  ),
                  title: Text(
                    AppStrings.gallery.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () async {
                    try {
                      var pickedfile = await imgpicker.pickImage(
                          source: ImageSource.gallery);
                      captainPhoto = pickedfile;
                      validateInputsToContinue();
                      setState(() {});
                    } catch (e) {
                      ShowDialogHelper.showErrorMessage(e.toString(), context);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.camera_alt_rounded,
                        color: ColorManager.primary, size: 24),
                  ),
                  title: Text(
                    AppStrings.camera.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () async {
                    try {
                      var pickedfile =
                          await imgpicker.pickImage(source: ImageSource.camera);
                      captainPhoto = pickedfile;
                      validateInputsToContinue();
                      setState(() {});
                    } catch (e) {
                      ShowDialogHelper.showErrorMessage(e.toString(), context);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '${AppStrings.welcomeInto.tr()} ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.blackTextColor,
                    fontSize: FontSize.s16,
                  ),
            ),
            Text(
              AppStrings.twsela.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: FontSize.s16,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s12),
        Text(
          AppStrings.pleaseResumePersonalData.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: ColorManager.blackTextColor,
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: -0.3,
              ),
        ),
      ],
    );
  }

  Widget _uploadCaptainPhoto() {
    final hasPhoto = captainPhoto != null && captainPhoto!.path != "";
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: openImages,
        borderRadius: BorderRadius.circular(16),
        splashColor: ColorManager.primary.withOpacity(0.08),
        highlightColor: ColorManager.primary.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
            vertical: AppPadding.p18,
          ),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.primary.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: ColorManager.primary.withOpacity(0.12),
                backgroundImage:
                    hasPhoto ? FileImage(File(captainPhoto!.path)) : null,
                child: hasPhoto
                    ? null
                    : Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: ColorManager.primary,
                      ),
              ),
              const SizedBox(width: AppSize.s16),
              Expanded(
                child: Text(
                  AppStrings.uploadCaptainPhoto.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: FontSize.s16,
                      ),
                ),
              ),
              Icon(
                hasPhoto
                    ? Icons.edit_rounded
                    : Icons.add_photo_alternate_rounded,
                color: ColorManager.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputFields() {
    const inputRadius = 12.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextInputField(
          labelText: AppStrings.firstName.tr(),
          showLabelText: true,
          hintText: AppStrings.enterFirstNameHere.tr(),
          validateSpecialCharacter: true,
          isCharacterOnly: true,
          borderRadius: inputRadius,
          onChanged: (value) {
            firstName = value;
            validateInputsToContinue();
          },
        ),
        CustomTextInputField(
          labelText: AppStrings.lastName.tr(),
          showLabelText: true,
          hintText: AppStrings.enterLastNameHere.tr(),
          validateSpecialCharacter: true,
          isCharacterOnly: true,
          borderRadius: inputRadius,
          onChanged: (value) {
            lastName = value;
            validateInputsToContinue();
          },
        ),
        CustomTextInputField(
          labelText: AppStrings.email.tr(),
          showLabelText: true,
          hintText: AppStrings.emailHint.tr(),
          validateEmptyString: false,
          validateEmail: true,
          borderRadius: inputRadius,
          onChanged: (value) {
            email = value;
            validateInputsToContinue();
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppMargin.m12),
          child: Text(
            AppStrings.birtDate.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: AppSize.s8),
        CustomDateOfBirth(),
        CustomTextInputField(
          labelText: AppStrings.nationalIdNumber.tr(),
          showLabelText: true,
          hintText: AppStrings.nationalIdNumberHint.tr(),
          validateEmptyString: true,
          keyboardType: TextInputType.number,
          borderRadius: inputRadius,
          onChanged: (value) {
            nationalIdNumber = value;
            validateInputsToContinue();
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppMargin.m12),
          child: Text(
            AppStrings.nationalIdExpiryDate.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: AppSize.s8),
        CustomNationalIdExpiryDateWidget(),
        const SizedBox(height: AppSize.s16),
        Row(
          children: [
            _genderChip(
              label: AppStrings.male.tr(),
              selected: isMale,
              onTap: () {
                setState(() {
                  isFemale = false;
                  isMale = true;
                  gender = 'M';
                  validateInputsToContinue();
                });
              },
            ),
            const SizedBox(width: AppSize.s12),
            _genderChip(
              label: AppStrings.female.tr(),
              selected: isFemale,
              onTap: () {
                setState(() {
                  isMale = false;
                  isFemale = true;
                  gender = 'F';
                  validateInputsToContinue();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: AppSize.s20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              side: BorderSide(
                color: ColorManager.primary.withOpacity(0.7),
                width: AppSize.s1_5,
              ),
              activeColor: ColorManager.primary,
              focusColor: ColorManager.primary,
              checkColor: ColorManager.white,
              value: agreeWithTerms,
              onChanged: (value) {
                setState(() {
                  agreeWithTerms = value!;
                  validateInputsToContinue();
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  children: [
                    Text(
                      '${AppStrings.iReadAndAgreeWith.tr()} ${AppStrings.termsAndConditions.tr()} ${AppStrings.tawsilaApplication.tr()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: FontSize.s14,
                            color: ColorManager.headersTextColor,
                            height: 1.4,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _genderChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: ColorManager.primary.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
            decoration: BoxDecoration(
              color: selected
                  ? ColorManager.primary.withOpacity(0.12)
                  : ColorManager.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    selected ? ColorManager.primary : ColorManager.borderColor,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: FontSize.s16,
                      color: selected
                          ? ColorManager.primary
                          : ColorManager.headersTextColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomDateOfBirth() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppMargin.m12, vertical: AppMargin.m4),
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16, vertical: AppPadding.p12),
        height: AppSize.s50,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorManager.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              birthDate != null
                  ? birthDate!.getTimeStampFromDate(pattern: 'dd MMM yyyy')
                  : AppStrings.birtDateHint.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: birthDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor,
                    fontSize: FontSize.s16,
                  ),
            ),
            Icon(Icons.calendar_today_rounded,
                color: ColorManager.primary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget CustomNationalIdExpiryDateWidget() {
    return GestureDetector(
      onTap: () => _selectNationalIdExpiryDate(context),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppMargin.m12, vertical: AppMargin.m4),
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16, vertical: AppPadding.p12),
        height: AppSize.s50,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorManager.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nationalIdExpiryDate != null
                  ? nationalIdExpiryDate!
                      .getTimeStampFromDate(pattern: 'dd MMM yyyy')
                  : AppStrings.nationalIdExpiryDateHint.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: nationalIdExpiryDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor,
                    fontSize: FontSize.s16,
                  ),
            ),
            Icon(Icons.calendar_today_rounded,
                color: ColorManager.primary, size: 22),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    // Calculate maximum date: today minus 18 years (must be at least 18 years old)
    final DateTime maxDate = DateTime(now.year - 18, now.month, now.day);
    // Use selected date if available, otherwise default to 25 years ago
    final DateTime initialDate =
        _defaultBirthDate.isBefore(maxDate) ? _defaultBirthDate : maxDate;

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1940, 1, 1),
        lastDate: maxDate);
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
        birthDate = picked.millisecondsSinceEpoch.toString();
        validateInputsToContinue();
      });
    }
  }

  Future<void> _selectNationalIdExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        nationalIdExpiryDate = selectedDate.millisecondsSinceEpoch.toString();
        validateInputsToContinue();
      });
    }
  }

  void validateInputsToContinue() {
    BlocProvider.of<ServiceRegistrationBloc>(context).add(addCaptainData(
        captainPhoto: captainPhoto!,
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        birthDate: birthDate,
        nationalIdNumber: nationalIdNumber,
        nationalIdExpiryDate: nationalIdExpiryDate,
        agreeWithTerms: agreeWithTerms));
  }
}

class captainRegistrationArgs {
  String mobileNumber;

  captainRegistrationArgs(this.mobileNumber);
}

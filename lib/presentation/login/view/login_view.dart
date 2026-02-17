import 'dart:developer' as developer;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taxi_for_you/domain/model/models.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/otp/view/verify_otp_view.dart';
import 'package:taxi_for_you/utils/helpers/language_helper.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
// import '../../../utils/resources/langauge_manager.dart'; // Commented out - not using Arabic format
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/login_bloc.dart';

class LoginView extends StatefulWidget {
  final String registerAs;

  LoginView({Key? key, required this.registerAs}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  CountryCodes selectedCountry = Constants.countryList.first;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Function()? onPressFun;
  String mobileNumber = "";
  final TextEditingController _controller = TextEditingController();
  String onChangValue = "";

  @override
  void initState() {
    // Set to Saudi Arabia only
    selectedCountry = Constants.countryList
        .firstWhere((country) => country.countryIsoCode == 'SA');
    setCountryCodeValue(selectedCountry);
    _appPreferences.setUserSelectedCountry(selectedCountry.countryIsoCode);
    super.initState();
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
          appBarActions: [
            SizedBox(
                child: Image.asset(
              ImageAssets.newAppBarLogo,
              color: ColorManager.splashBGColor,
            ))
          ]),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginIsAllInputNotValid) {
          onPressFun = null;
        } else if (state is LoginIsAllInputValid) {
          onPressFun = () {
            FocusScope.of(context).unfocus();
            String validMobileNumber =
                LanguageHelper().replaceEnglishNumber(mobileNumber);
            // BlocProvider.of<LoginBloc>(context).add(MakeLoginEvent(
            //     validMobileNumber, _appPreferences.getAppLanguage()));
            Navigator.pushNamed(context, Routes.verifyOtpRoute,
                arguments: VerifyArguments(
                  validMobileNumber,
                  mobileNumber,
                  selectedCountry.countryIsoCode,
                  widget.registerAs,
                ));
          };
        } else if (state is LoginIsAllInputNotValid) {
          onPressFun = null;
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Container(
                padding: const EdgeInsets.only(
                    top: AppPadding.p40,
                    right: AppPadding.p20,
                    left: AppPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.welcomeInto.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          width: AppSize.s8,
                        ),
                        Text(
                          AppStrings.twsela.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ColorManager.primary),
                        ),
                      ],
                    ),
                    Text(
                      AppStrings.enterPhoneNumberToContinue.tr(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: FontSize.s26),
                    ),
                    const SizedBox(
                      height: AppSize.s18,
                    ),
                    phoneNumberWidget(),
                    const SizedBox(
                      height: AppSize.s30,
                    ),
                    CustomTextButton(
                      onPressed: onPressFun,
                      text: AppStrings.continueStr.tr(),
                      borderRadius: BorderRadius.circular(12),
                      icon: Icon(
                        Icons.arrow_forward,
                        color: onPressFun != null
                            ? ColorManager.white
                            : ColorManager.disableTextColor,
                      ),
                    ),
                    const Spacer(),
                  ],
                )),
          ),
        );
      },
    );
  }

  // Bottom sheet disabled - only Saudi Arabia country code is available
  // void _showBottomSheet() {
  //   showModalBottomSheet(
  //       elevation: 10,
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (ctx) => Container(
  //           height: 150,
  //           decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(16),
  //                   topRight: Radius.circular(16))),
  //           alignment: Alignment.center,
  //           child: ListView.builder(
  //             itemCount: _appPreferences.getCountries().length,
  //             itemBuilder: (context, index) {
  //               final selectedCountry = Constants.countryList[index];
  //               _appPreferences
  //                   .setUserSelectedCountry(selectedCountry.countryIsoCode);
  //               return InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     setCountryCodeValue(selectedCountry);
  //                     Navigator.pop(context);
  //                   });
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(AppPadding.p12),
  //                   child: Row(
  //                     children: [
  //                       Image.asset(
  //                         selectedCountry.flagPath,
  //                         width: AppSize.s20,
  //                       ),
  //                       const SizedBox(
  //                         width: AppSize.s8,
  //                       ),
  //                       Text(
  //                         '(${selectedCountry.countryPhoneKey.tr()})',
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .titleMedium
  //                             ?.copyWith(color: ColorManager.blackTextColor),
  //                       ),
  //                       const SizedBox(
  //                         width: AppSize.s8,
  //                       ),
  //                       Text(
  //                         selectedCountry.countryName.tr(),
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .titleMedium
  //                             ?.copyWith(color: ColorManager.blackTextColor),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           )));
  // }

  Widget phoneNumberWidget() {
    // Force left-to-right direction for phone number and country code
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            // Country code selector - disabled tap functionality (only Saudi Arabia available)
            child: Container(
              height: AppSize.s47,
              decoration: BoxDecoration(
                  color: ColorManager.forthAccentColor,
                  borderRadius: BorderRadius.circular(2)),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          // Always show country code in English format
                          '+966',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s16),
                        ),
                        const SizedBox(
                          width: AppSize.s4,
                        ),
                        Image.asset(
                          selectedCountry.flagPath,
                          width: AppSize.s16,
                          height: AppSize.s16,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: CustomTextInputField(
              // Prevent leading zero after country code - using English format only
              inputFormatter: [NoLeadingZeroFormatter()],
              controller: _controller,
              borderColor: ColorManager.white,
              fillColor: ColorManager.thirdAccentColor,
              textColor: ColorManager.blackTextColor,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              maxLength:
                  9, // Saudi Arabia mobile numbers are 9 digits after country code
              onChanged: (value) {
                // Using English format only - Arabic number conversion commented out
                // String englishValue = LanguageHelper().replaceEnglishNumber(value);

                // Log the entered number for debugging
                developer.log(
                    '📱 Phone Number Input - English: $value, Length: ${value.length}');

                onChangValue = value;
                // Use English country code for API calls
                String englishCountryCode = '+966';
                // Directly use value since we're not converting from Arabic anymore
                mobileNumber = englishCountryCode + value;

                // Log the complete mobile number
                developer.log('📱 Complete Mobile Number: $mobileNumber');

                BlocProvider.of<LoginBloc>(context)
                    .add(CheckInputIsValidEvent(value));
              },
            ),
          ),
        ],
      ),
    );
  }

  // Arabic country code display - commented out, using English format only
  // String _getCountryCodeForDisplay() {
  //   // Check if Arabic is selected
  //   String appLang = _appPreferences.getAppLanguage();
  //   const lrm = '\u200E'; // Left-to-Right Mark to force LTR display

  //   if (appLang == LanguageType.ARABIC.getValue()) {
  //     // Convert to Arabic numerals and format as +numbers (LTR)
  //     String arabicNumbers = LanguageHelper().replaceArabicNumber('966');
  //     return '$lrm+$arabicNumbers'; // +٦٦٩ in LTR format
  //   } else {
  //     // English format
  //     return '+966';
  //   }
  // }

  void setCountryCodeValue(CountryCodes selectedCountry) {
    this.selectedCountry = selectedCountry;
    // Using English format only - Arabic number conversion commented out
    // Keep the translation key for display, but use English number for API calls
    // The countryPhoneKey is already set from Constants with the translation key
    // For mobileNumber construction, we need English numbers
    String englishCountryCode = '+966'; // Always use English for API
    // Directly use onChangValue since we're not converting from Arabic anymore
    // mobileNumber = englishCountryCode + LanguageHelper().replaceEnglishNumber(onChangValue);
    mobileNumber = englishCountryCode + onChangValue;
  }
}

class LoginViewArguments {
  String registerAs;

  LoginViewArguments(this.registerAs);
}

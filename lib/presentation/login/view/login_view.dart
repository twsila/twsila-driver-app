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
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/login_bloc.dart';

class LoginView extends StatefulWidget {
  final String registerAs;

  const LoginView({Key? key, required this.registerAs}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  CountryCodes selectedCountry = Constants.countryList.first;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  VoidCallback? onPressFun;
  String mobileNumber = "";
  final TextEditingController _controller = TextEditingController();
  String onChangValue = "";

  @override
  void initState() {
    selectedCountry = Constants.countryList.firstWhere(
      (country) => country.countryIsoCode == Constants.saudiArabiaIsoCode,
    );
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
        if (state is LoginIsAllInputValid) {
          onPressFun = () {
            FocusScope.of(context).unfocus();
            final String validMobileNumber =
                LanguageHelper().replaceEnglishNumber(mobileNumber);
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
                        const SizedBox(width: AppSize.s8),
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
                    const SizedBox(height: AppSize.s18),
                    phoneNumberWidget(),
                    const SizedBox(height: AppSize.s30),
                    CustomTextButton(
                      onPressed: onPressFun,
                      text: AppStrings.continueStr.tr(),
                      borderRadius: BorderRadius.circular(AppSize.s12),
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

  Widget phoneNumberWidget() {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: AppSize.s47,
              decoration: BoxDecoration(
                  color: ColorManager.forthAccentColor,
                  borderRadius: BorderRadius.circular(AppSize.s2)),
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
                          Constants.saudiArabiaPhoneCode,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s16),
                        ),
                        const SizedBox(width: AppSize.s4),
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
              inputFormatter: [NoLeadingZeroFormatter()],
              controller: _controller,
              borderColor: ColorManager.white,
              fillColor: ColorManager.thirdAccentColor,
              textColor: ColorManager.blackTextColor,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              maxLength: Constants.saudiArabiaMobileDigits,
              onChanged: (value) {
                developer.log(
                    '📱 Phone Number Input - English: $value, Length: ${value.length}');

                onChangValue = value;
                mobileNumber = Constants.saudiArabiaPhoneCode + value;

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

  void setCountryCodeValue(CountryCodes selectedCountry) {
    this.selectedCountry = selectedCountry;
    mobileNumber = Constants.saudiArabiaPhoneCode + onChangValue;
  }
}

class LoginViewArguments {
  String registerAs;

  LoginViewArguments(this.registerAs);
}

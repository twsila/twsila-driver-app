import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:taxi_for_you/data/network/error_handler.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_screen.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/presentation/otp/bloc/verify_otp_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/captain_registraion.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/helpers/language_helper.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/CustomAutoFullSms.dart';
import '../../common/widgets/custom_countdown_timer.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class VerifyOtpView extends StatefulWidget {
  final String mobileNumberForApi;
  final String mobileNumberForDisplay;
  final String countryCode;
  final String registerAs;

  VerifyOtpView({
    required this.mobileNumberForApi,
    required this.mobileNumberForDisplay,
    required this.countryCode,
    required this.registerAs,
  });

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  GlobalKey globalKey = GlobalKey();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool isTimerFinished = false;

  String generatedOtp = "";
  static const String TEST_NUMBER = "+966505919199";

  TextEditingController otpController = TextEditingController();

  // Check if the number is the test number (handles different formats)
  bool _isTestNumber(String mobileNumber) {
    // Remove all non-digit characters for comparison
    String normalizedNumber = mobileNumber.replaceAll(RegExp(r'[^\d]'), '');
    String testNumberNormalized = TEST_NUMBER.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it matches the test number (with or without country code)
    return normalizedNumber == testNumberNormalized ||
        normalizedNumber ==
            testNumberNormalized.substring(3) || // Without country code
        normalizedNumber ==
            "0${testNumberNormalized.substring(3)}"; // With leading 0
  }

  @override
  void initState() {
    //TODO Return sendOtp Feature
    BlocProvider.of<VerifyOtpBloc>(context)
        .add(SendOtpEvent(widget.mobileNumberForApi));
    // if (widget.registerAs == RegistrationConstants.captain) {
    //   BlocProvider.of<LoginBloc>(context).add(MakeLoginEvent(
    //       /*'1234567890'*/
    //       widget.mobileNumberForApi,
    //       widget.countryCode));
    // } else {
    //   BlocProvider.of<LoginBloc>(context).add(MakeLoginBOEvent(
    //       /*'1234567890'*/
    //       widget.mobileNumberForApi,
    //       widget.countryCode));
    // }
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
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
        resizeToAvoidBottomInsets: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) async {
              if (state is LoginLoadingState) {
                startLoading();
              } else {
                stopLoading();
              }

              if (state is LoginSuccessButDisabled) {
                BlocProvider.of<LoginBloc>(context)
                    .add(SaveUserAllowedList(state.driver));
              }
              if (state is LoginSuccessState) {
                startLoading();
                await LoginBloc().setUserInfoAndModelToCache(
                    state.driver, widget.registerAs);

                stopLoading();
                Navigator.pushReplacementNamed(context, Routes.mainRoute);
              }
              if (state is LoginFailState) {
                if ((state.errorCode == ResponseCode.NOT_FOUND.toString() ||
                        state.errorCode ==
                            ResponseCode.BAD_REQUEST.toString() ||
                        state.errorCode ==
                            ResponseCode.INTERNAL_SERVER_ERROR.toString()) &&
                    widget.registerAs == RegistrationConstants.captain) {
                  Navigator.pushReplacementNamed(
                      context, Routes.captainRegisterRoute,
                      arguments:
                          captainRegistrationArgs(widget.mobileNumberForApi));
                } else if (widget.registerAs ==
                    RegistrationConstants.businessOwner) {
                  Navigator.pushNamed(context, Routes.boRegistration,
                      arguments: BoRegistrationArguments(
                          widget.mobileNumberForApi, widget.countryCode));
                } else {
                  CustomDialog(context).showErrorDialog('', '', state.message);
                }
              }
            },
            child: const SizedBox(),
          ),
          BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
            listener: (context, state) async {
              if (state is VerifyOtpLoading) {
                startLoading();
              } else {
                stopLoading();
              }
              if (state is GenerateOtpSuccess) {
                this.generatedOtp = state.otp;

                // Check if this is the test number and show toast
                if (_isTestNumber(widget.mobileNumberForApi)) {
                  // Show toast for test number
                  ToastHandler(context).showToast(
                    "This is test number. OTP: ${state.otp}",
                    Toast.LENGTH_LONG,
                  );
                }
              }
              if (state is GenerateOtpFail) {
                CustomDialog(context).showErrorDialog(
                    "", "", AppStrings.cannotSendOtp.tr(), onBtnPressed: () {
                  Navigator.pop(context);
                });
              }
              if (state is VerifyOtpSuccess) {
                BlocProvider.of<VerifyOtpBloc>(context)
                    .add(GetCoastCalculationsDataEvent());
              }

              if (state is gettingCoastCalculationsSuccess) {
                await _appPreferences
                    .setCoastCalculationData(state.calculationModel);
                ToastHandler(context)
                    .showToast(AppStrings.otpValidated.tr(), Toast.LENGTH_LONG);
                if (widget.registerAs == RegistrationConstants.captain) {
                  BlocProvider.of<LoginBloc>(context).add(MakeLoginEvent(
                      widget.mobileNumberForApi, widget.countryCode));
                } else {
                  BlocProvider.of<LoginBloc>(context).add(MakeLoginBOEvent(
                    widget.mobileNumberForApi,
                    widget.countryCode,
                  ));
                }
              }
              if (state is VerifyOtpFail) {
                if (state.code == ResponseMessage.NOT_FOUND) {
                  CustomDialog(context)
                      .showErrorDialog("", "", AppStrings.wrongOtp.tr());
                } else {
                  CustomDialog(context).showErrorDialog("", "", state.message);
                }
              }
            },
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSize.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: AppSize.s40,
                    ),
                    Text(
                      AppStrings.enterVerificationCode.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: FontSize.s26),
                    ),
                    Text(
                      AppStrings.enterHereSentCodeForNumber.tr(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: FontSize.s16,
                          color: ColorManager.formLabelTextColor),
                    ),
                    Text(
                      LanguageHelper()
                          .replaceArabicNumber(widget.mobileNumberForDisplay),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: FontSize.s16,
                          color: ColorManager.blackTextColor),
                    ),
                    const SizedBox(
                      height: AppSize.s30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomVerificationCodeWidget(
                        autoFocus: false,
                        onCodeSubmitted: (code) {
                          BlocProvider.of<VerifyOtpBloc>(context).add(
                              VerifyOtpBEEvent(widget.mobileNumberForApi, code,
                                  this.generatedOtp));
                        },
                        controller: otpController,
                        onCodeChanged: (otpChangedValue) {},
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s30,
                    ),
                    Text(
                      AppStrings.didNotReceiveTheCode.tr(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: FontSize.s16,
                          color: ColorManager.blackTextColor),
                    ),
                    const SizedBox(
                      height: AppSize.s4,
                    ),
                    isTimerFinished
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                isTimerFinished = false;
                                BlocProvider.of<VerifyOtpBloc>(context).add(
                                    ReSendOtpEvent(widget.mobileNumberForApi));
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssets.retryIcon,
                                  width: AppSize.s16,
                                ),
                                const SizedBox(
                                  width: AppSize.s10,
                                ),
                                Text(
                                  AppStrings.resendCode.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize.s16,
                                          color: ColorManager.primary),
                                ),
                              ],
                            ))
                        : CustomCountDownTimer(
                            onTimerFinished: () {
                              setState(() {
                                isTimerFinished = true;
                              });
                            },
                          ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class VerifyArguments {
  String mobileNumberForApi;
  String mobileNumberForDisplay;
  String countryCode;
  String registerAs;

  VerifyArguments(this.mobileNumberForApi, this.mobileNumberForDisplay,
      this.countryCode, this.registerAs);
}

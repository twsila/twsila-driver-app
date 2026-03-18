import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/domain/usecase/countries_lookup_usecase.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/utils/push_notification/firebase_messaging_helper.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../utils/dialogs/custom_dialog.dart';
import '../../utils/location/map_provider.dart';
import '../../utils/resources/assets_manager.dart';
import '../../utils/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _isInit = true;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  CountriesLookupUseCase countriesLookupUseCase =
      instance<CountriesLookupUseCase>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorManager.splashBGColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: ColorManager.splashBGColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    start();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      setCountry();
    }
    super.didChangeDependencies();
  }

  setCountry() {
    var country = _appPreferences.getUserSelectedCountry();
    Provider.of<MapProvider>(context, listen: false)
        .setCountry(country ?? "SA", needsRebuild: false);
  }

  start() async {
    try {
      await FirebaseMessagingHelper().configure(context);
    } catch (e) {
      // Log the error but don't block the app initialization
      debugPrint('[Splash] Firebase messaging configuration failed: $e');
    }

    // Initialize login module in case we need to refresh token
    initLoginModule();

    // Check if user is logged in (has stored user data)
    final isUserLoggedIn = await _appPreferences.isUserLoggedIn();
    final cachedDriver = _appPreferences.getCachedDriver();

    if (isUserLoggedIn && cachedDriver != null) {
      // User is logged in - refresh token and go to home
      refreshToken(cachedDriver);
    } else {
      // User is not logged in - show onboarding after splash
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _goToOnboardingOrLogin();
        }
      });
    }
  }

  refreshToken(DriverBaseModel driver) {
    // Get mobile number from cached driver and trigger login to refresh token
    String? mobileNumber = driver.mobile;
    String countryCode =
        _appPreferences.getUserSelectedCountry() == "SA" ? "+966" : "+20";

    if (mobileNumber != null && mobileNumber.isNotEmpty) {
      BlocProvider.of<LoginBloc>(context)
          .add(MakeLoginEvent(mobileNumber, countryCode));
    } else {
      // If no mobile number, go to login
      _goToOnboardingOrLogin();
    }
  }

  getLookups() async {
    (await countriesLookupUseCase.execute(LookupsUseCaseInput())).fold(
        (failure) => {
              // If lookups fail, still proceed to main screen
              _goNext()
            }, (countries) async {
      _appPreferences.setCountries(countries);
      _goNext();
    });
  }

  _goNext() {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) {
      if (isUserLoggedIn) {
        // navigate to main screen
        Navigator.pushReplacementNamed(context, Routes.mainRoute);
      } else {
        // Navigate to Onboarding Screen (user not logged in)
        _goToOnboardingOrLogin();
      }
    });
  }

  _goToOnboardingOrLogin() async {
    // Check if onboarding has been seen
    bool isOnboardingSeen = await _appPreferences.isOnBoardingScreenViewed();
    if (!isOnboardingSeen) {
      // Navigate to Onboarding Screen
      Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
    } else {
      // Navigate to Login Screen
      Navigator.pushReplacementNamed(context, Routes.selectRegistrationType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.splashBGColor,
      body: SizedBox.expand(
        child: _getContentWidget(context),
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ColorManager.splashBGColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSize.s320,
              height: AppSize.s320,
              child: Image.asset(
                ImageAssets.splashIc,
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<LoginBloc, LoginState>(
              listener: ((context, state) {
                if (state is LoginFailState) {
                  // If login fails, show error and go to login/onboarding
                  String errorMessage = state.message.isNotEmpty
                      ? state.message
                      : AppStrings.noInternetError.tr();
                  CustomDialog(context).showErrorDialog(
                    '',
                    '',
                    errorMessage,
                    onBtnPressed: () {
                      Navigator.pop(context);
                      _goToOnboardingOrLogin();
                    },
                  );
                } else if (state is LoginSuccessState) {
                  // Login successful, get lookups then navigate
                  getLookups();
                } else if (state is LoginSuccessButDisabled) {
                  // User is disabled, still get lookups
                  getLookups();
                }
              }),
              builder: ((context, state) {
                // Show loading indicator if logging in
                if (state is LoginLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                return const SizedBox();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

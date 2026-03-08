import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:taxi_for_you/presentation/bo_program_subscribtion/view/bo_subscription_benefits.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_screen.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/welcome_to_twsila_view.dart';
import 'package:taxi_for_you/presentation/business_owner_add_driver/view/bo_add_driver_view.dart';
import 'package:taxi_for_you/presentation/custom_widgets_view.dart';
import 'package:taxi_for_you/presentation/driver_add_requests/view/driver_add_requests_view.dart';
import 'package:taxi_for_you/presentation/my_serivces/view/my_services_view.dart';
import 'package:taxi_for_you/presentation/otp/view/verify_otp_view.dart';
import 'package:taxi_for_you/presentation/payment/view/payment_screen.dart';
import 'package:taxi_for_you/presentation/rate_passenger/view/rate_passenger_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/captain_registraion.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_applyed_success_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_details_view.dart';
import 'package:taxi_for_you/presentation/update_bo_profile/view/update_bo_profile_view.dart';
import 'package:taxi_for_you/presentation/update_driver_profile/view/update_driver_profile_view.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../app/di.dart';
import '../../presentation/business_owner_cars_and_drivers/view/bo_cars_and_drivers_view.dart';
import '../../presentation/edit_user_profile/view/edit_profile_view.dart';
import '../../presentation/filter_trips/view/filter_trips_view.dart';
import '../../presentation/login/view/login_view.dart';
import '../../presentation/main/main_view.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/select_registation_type/view/registration_type_view.dart';
import '../../presentation/service_registration/view/pages/no_service_added_view.dart';
import '../../presentation/splash/splash_view.dart';
import '../../presentation/trip_execution/view/navigation_tracking_view.dart';
import '../../presentation/trip_execution/view/trip_execution_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String captainRegisterRoute = "/captainRegister";
  static const String goodsRegisterRoute = "/goodsRegister";
  static const String registerUploadDocumentsRoute =
      "/registerUploadDocumentsRoute";
  static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
  static const String verifyOtpRoute = "/verifyOtp";
  static const String categoriesRoute = "/categories";
  static const String goodsRoute = "/goods";
  static const String furnitureRoute = "/furniture";
  static const String pendingApprovalRoute = "/pendingApproval";
  static const String tripsRoute = "/trips";
  static const String tripDetailsRoute = "/tripDetails";
  static const String tripClientDetailsRoute = "/tripClientDetails";
  static const String immediateTrip = "/immediateTrip";
  static const String scheduledTrip = "/scheduledTrip";
  static const String canceledTrip = "/canceledTrip";
  static const String customWidgetsTest = "/customWidgetsTest";
  static const String selectRegistrationType = "/selectRegistrationType";
  static const String noServicesAdded = "/noServicesAdded";
  static const String serviceRegistrationFirstStep =
      "/serviceRegistrationFirstStep";
  static const String serviceRegistrationSecondStep =
      "/serviceRegistrationSecondStep";
  static const String serviceAppliedSuccessfullyView =
      "/serviceAppliedSuccessfullyView";
  static const String myServices = "/myServices";
  static const String uploadDocument = "/uploadDocument";
  static const String tripDetails = "/tripDetails";
  static const String tripExecution = "/tripExecution";
  static const String locationTrackingPage = "/locationTrackingPage";
  static const String ratePassenger = "/ratePassenger";
  static const String editProfile = "/editProfile";
  static const String updateDriverProfile = "/updateDriverProfile";
  static const String updateBoProfile = "/updateBoProfile";
  static const String boRegistration = "/boRegistration";
  static const String filterTrips = "/filterTrips";
  static const String welcomeToTwsilaBO = "/welcomeToTwsilaBO";
  static const String boDriversAndCars = "/boDriversAndCars";
  static const String BOaddDriver = "/BOaddDriver";
  static const String driverRequests = "/driverRequests";
  static const String paymentScreen = "/paymentScreen";
  static const String boSubscriptionBenefits = "/boSubscriptionBenefits";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        initSplashModule();
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.loginRoute:
        initLoginModule();
        final args = settings.arguments as LoginViewArguments;
        return MaterialPageRoute(
          builder: (_) => LoginView(
            registerAs: args.registerAs,
          ),
        );
      case Routes.serviceRegistrationFirstStep:
        initRegistrationServiceModule();
        final args =
            settings.arguments as ServiceRegistrationFirstStepArguments;
        return MaterialPageRoute(
            builder: (_) => ServiceRegistrationFirstStepView(
                  requestModel: args.registrationRequest,
                ));
      case Routes.serviceRegistrationSecondStep:
        initRegistrationServiceModule();
        final args =
            settings.arguments as ServiceRegistrationSecondStepArguments;
        return MaterialPageRoute(
            builder: (_) => ServiceRegistrationSecondStep(
                  registrationRequest: args.registrationRequest,
                ));
      case Routes.myServices:
        initServiceStatusModule();
        return MaterialPageRoute(builder: (_) => const MyServicesView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.captainRegisterRoute:
        final args = settings.arguments as captainRegistrationArgs;
        return MaterialPageRoute(
            builder: (_) => CaptainRegistrationView(
                  mobileNumber: args.mobileNumber,
                ));
      case Routes.mainRoute:
        initLogoutModule();
        initMyTripsModule();
        initLookupsModule();
        initTripsModule();
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.verifyOtpRoute:
        final args = settings.arguments as VerifyArguments;
        initVerifyOtpModule();
        return MaterialPageRoute(
            builder: (_) => VerifyOtpView(
                  mobileNumberForApi: args.mobileNumberForApi,
                  mobileNumberForDisplay: args.mobileNumberForDisplay,
                  countryCode: args.countryCode,
                  registerAs: args.registerAs,
                ));
      case Routes.tripDetails:
        initTripDetailsModule();
        final args = settings.arguments as TripDetailsArguments;
        return MaterialPageRoute(
            builder: (_) => TripDetailsView(
                  tripModel: args.tripModel,
                ));
      case Routes.tripExecution:
        initTripExecutionModule();
        final args = settings.arguments as TripExecutionArguments;
        return MaterialPageRoute(
            builder: (_) => TripExecutionView(
                  tripModel: args.tripModel,
                ));
      case Routes.noServicesAdded:
        return MaterialPageRoute(builder: (_) => const NoServiceAddedView());
      case Routes.ratePassenger:
        initRatePassengerModule();
        final args = settings.arguments as RatePassengerArguments;
        return MaterialPageRoute(
          builder: (_) => RatePassengerView(
            tripDetailsModel: args.tripDetailsModel,
          ),
        );
      case Routes.serviceAppliedSuccessfullyView:
        return MaterialPageRoute(
            builder: (_) => const ServiceAppliedSuccessView());
      case Routes.customWidgetsTest:
        return MaterialPageRoute(builder: (_) => const CustomWidgetsView());
      case Routes.selectRegistrationType:
        return MaterialPageRoute(builder: (_) => const RegistrationTypesView());
      case Routes.editProfile:
        final args = settings.arguments as EditProfileArguments;
        return MaterialPageRoute(
          builder: (_) => EditProfileView(
            driver: args.driver,
          ),
        );
      case Routes.updateDriverProfile:
        initUpdateDriverProfileModule();
        final args = settings.arguments as UpdateDriverProfileArguments;
        return MaterialPageRoute(
            builder: (_) => UpdateDriverProfileView(
                  driver: args.driver,
                ));
      case Routes.updateBoProfile:
        initUpdateBoProfileModule();
        final args = settings.arguments as UpdateBoProfileArguments;
        return MaterialPageRoute(
            builder: (_) => UpdateBoProfileView(
                  boUser: args.businessOwnerModel,
                ));
      case Routes.filterTrips:
        initFilterModule();
        return MaterialPageRoute(
            builder: (_) => FilterTripsView(
                // driver: args.driver,
                ));
      case Routes.boRegistration:
        initLoginModule();
        initRegistrationServiceModule();
        final args = settings.arguments as BoRegistrationArguments;
        return MaterialPageRoute(
            builder: (_) => RegisterBusinessOwnerScreen(
                  mobileNumber: args.mobileNumber,
                  countryCode: args.countryCode,
                ));
      case Routes.welcomeToTwsilaBO:
        return MaterialPageRoute(builder: (_) => WelcomeToTwsilaView());
      case Routes.boDriversAndCars:
        initBODriversCarsModule();
        return MaterialPageRoute(builder: (_) => BOCarsAndDriversView());
      case Routes.BOaddDriver:
        return MaterialPageRoute(builder: (_) => BOAddDriverView());
      case Routes.driverRequests:
        initDriverRequestsModule();
        return MaterialPageRoute(builder: (_) => DriverAddRequestsView());
      case Routes.paymentScreen:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case Routes.boSubscriptionBenefits:
        return MaterialPageRoute(
            builder: (_) => const BoSubscriptionBenefits());
      case Routes.locationTrackingPage:
        final args = settings.arguments as NavigationTrackingArguments;
        return MaterialPageRoute(
            builder: (_) => TrackingPage(
                  tripModel: args.tripModel,
                  currentStepIndex: args.currentStepIndex,
                  currentTripStatus: args.currentTripStatus,
                ));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound.tr()),
              ),
              body: Center(child: Text(AppStrings.noRouteFound.tr())),
            ));
  }
}

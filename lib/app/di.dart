import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/domain/usecase/accept_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/add_driver_bo_usecase.dart';
import 'package:taxi_for_you/domain/usecase/add_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/add_requests_usecase.dart';
import 'package:taxi_for_you/domain/usecase/allowed_services_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_accept_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_assign_driver_to_trip_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_get_pending_drivers_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_suggest_new_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/car_brands_usecase.dart';
import 'package:taxi_for_you/domain/usecase/car_manufacturer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/change_request_status.dart';
import 'package:taxi_for_you/domain/usecase/change_trip_status_usecase.dart';
import 'package:taxi_for_you/domain/usecase/coast_calculation_usecase.dart';
import 'package:taxi_for_you/domain/usecase/get_business_owner_drivers_usecase.dart';
import 'package:taxi_for_you/domain/usecase/logout_usecase.dart';
import 'package:taxi_for_you/domain/usecase/lookup_by_key_usecase.dart';
import 'package:taxi_for_you/domain/usecase/lookups_usecase.dart';
import 'package:taxi_for_you/domain/usecase/rate_passenger_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_bo_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_services_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_usecase.dart';
import 'package:taxi_for_you/domain/usecase/search_driver_mobile_usecase.dart';
import 'package:taxi_for_you/domain/usecase/service_status_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trip_summary_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';
import 'package:taxi_for_you/domain/usecase/update_driver_profile_usecase.dart';
import 'package:taxi_for_you/domain/usecase/verify_otp_usecase.dart';

import '../data/data_source/local_data_source.dart';
import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/countries_lookup_usecase.dart';
import '../domain/usecase/generate_otp_usecase.dart';
import '../domain/usecase/goods_service_types_usecase.dart';
import '../domain/usecase/login_usecase.dart';
import '../domain/usecase/mytrips_usecase.dart';
import '../domain/usecase/persons_vehicle_types_usecase.dart';
import '../domain/usecase/update_bo_profile_request.dart';
import '../flavors.dart';
import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  String baseUrl = F.baseUrl;
  //app service client
  instance.registerLazySingleton<AppServiceClient>(
      () => AppServiceClient(dio, baseUrl: baseUrl));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initSplashModule() {
  if (!GetIt.I.isRegistered<CountriesLookupUseCase>()) {
    instance.registerFactory<CountriesLookupUseCase>(
        () => CountriesLookupUseCase(instance()));
  }
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<LoginBOUseCase>()) {
    instance.registerFactory<LoginBOUseCase>(() => LoginBOUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<AllowedServicesUseCase>()) {
    instance.registerFactory<AllowedServicesUseCase>(
        () => AllowedServicesUseCase(instance()));
  }
}

initVerifyOtpModule() {
  if (!GetIt.I.isRegistered<VerifyOtpUseCase>()) {
    instance
        .registerFactory<VerifyOtpUseCase>(() => VerifyOtpUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<GenerateOtpUseCase>()) {
    instance.registerFactory<GenerateOtpUseCase>(
        () => GenerateOtpUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<CoastCalculationUseCase>()) {
    instance.registerFactory<CoastCalculationUseCase>(
        () => CoastCalculationUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
  }
}

initGenerateOtpModule() {
  if (!GetIt.I.isRegistered<GenerateOtpUseCase>()) {
    instance.registerFactory<GenerateOtpUseCase>(
        () => GenerateOtpUseCase(instance()));
  }
}

initRegistrationServiceModule() {
  if (!GetIt.I.isRegistered<RegistrationServiceUseCase>()) {
    instance.registerFactory<RegistrationServiceUseCase>(
        () => RegistrationServiceUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<CarBrandsAndModelsUseCase>()) {
    instance.registerFactory<CarBrandsAndModelsUseCase>(
        () => CarBrandsAndModelsUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<CarManufacturerUseCase>()) {
    instance.registerFactory<CarManufacturerUseCase>(
        () => CarManufacturerUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<RegistrationUseCase>()) {
    instance.registerFactory<RegistrationUseCase>(
        () => RegistrationUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<GoodsServiceTypesUseCase>()) {
    instance.registerFactory<GoodsServiceTypesUseCase>(
        () => GoodsServiceTypesUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<PersonsVehicleTypesUseCase>()) {
    instance.registerFactory<PersonsVehicleTypesUseCase>(
        () => PersonsVehicleTypesUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<RegistrationBOUseCase>()) {
    instance.registerFactory<RegistrationBOUseCase>(
        () => RegistrationBOUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<LookupByKeyUseCase>()) {
    instance.registerFactory<LookupByKeyUseCase>(
        () => LookupByKeyUseCase(instance()));
  }
}

initServiceStatusModule() {
  if (!GetIt.I.isRegistered<ServiceStatusUseCase>()) {
    instance.registerFactory<ServiceStatusUseCase>(
        () => ServiceStatusUseCase(instance()));
  }
}

initFilterModule() {
  if (!GetIt.I.isRegistered<LookupByKeyUseCase>()) {
    instance.registerFactory<LookupByKeyUseCase>(
        () => LookupByKeyUseCase(instance()));
  }
}

initLogoutModule() {
  if (!GetIt.I.isRegistered<LogoutUseCase>()) {
    instance.registerFactory<LogoutUseCase>(() => LogoutUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BoLogoutUseCase>()) {
    instance
        .registerFactory<BoLogoutUseCase>(() => BoLogoutUseCase(instance()));
  }
}

initTripsModule() {
  if (!GetIt.I.isRegistered<TripsUseCase>()) {
    instance.registerFactory<TripsUseCase>(() => TripsUseCase(instance()));
  }
}

initTripExecutionModule() {
  if (!GetIt.I.isRegistered<ChangeTripStatusUseCase>()) {
    instance.registerFactory<ChangeTripStatusUseCase>(
        () => ChangeTripStatusUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<TripSummaryUseCase>()) {
    instance.registerFactory<TripSummaryUseCase>(
        () => TripSummaryUseCase(instance()));
  }
}

initTripDetailsModule() {
  if (!GetIt.I.isRegistered<AcceptOfferUseCase>()) {
    instance.registerFactory<AcceptOfferUseCase>(
        () => AcceptOfferUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<AddOfferUseCase>()) {
    instance
        .registerFactory<AddOfferUseCase>(() => AddOfferUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BOAcceptOfferUseCase>()) {
    instance.registerFactory<BOAcceptOfferUseCase>(
        () => BOAcceptOfferUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BoSuggestNewOfferUseCase>()) {
    instance.registerFactory<BoSuggestNewOfferUseCase>(
        () => BoSuggestNewOfferUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<TripSummaryUseCase>()) {
    instance.registerFactory<TripSummaryUseCase>(
        () => TripSummaryUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BusinessOwnerDriversUseCase>()) {
    instance.registerFactory<BusinessOwnerDriversUseCase>(
        () => BusinessOwnerDriversUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BoAssignDriverToTripUseCase>()) {
    instance.registerFactory<BoAssignDriverToTripUseCase>(
        () => BoAssignDriverToTripUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BOGetPendingDriversUseCase>()) {
    instance.registerFactory<BOGetPendingDriversUseCase>(
        () => BOGetPendingDriversUseCase(instance()));
  }
}

initMyTripsModule() {
  if (!GetIt.I.isRegistered<MyTripsUseCase>()) {
    instance.registerFactory<MyTripsUseCase>(() => MyTripsUseCase(instance()));
  }
}

initAcceptOfferModule() {
  if (!GetIt.I.isRegistered<AcceptOfferUseCase>()) {
    instance.registerFactory<AcceptOfferUseCase>(
        () => AcceptOfferUseCase(instance()));
  }
}

initAddOfferModule() {
  if (!GetIt.I.isRegistered<AddOfferUseCase>()) {
    instance
        .registerFactory<AddOfferUseCase>(() => AddOfferUseCase(instance()));
  }
}

initTripSummaryModule() {
  if (!GetIt.I.isRegistered<TripSummaryUseCase>()) {
    instance.registerFactory<TripSummaryUseCase>(
        () => TripSummaryUseCase(instance()));
  }
}

initLoopkupsModule() {
  if (!GetIt.I.isRegistered<LookupsUseCase>()) {
    instance.registerFactory<LookupsUseCase>(() => LookupsUseCase(instance()));
  }
}

initChangeTripStatusModule() {
  if (!GetIt.I.isRegistered<ChangeTripStatusUseCase>()) {
    instance.registerFactory<ChangeTripStatusUseCase>(
        () => ChangeTripStatusUseCase(instance()));
  }
}

initRatePassengerModule() {
  if (!GetIt.I.isRegistered<RatePassengerUseCase>()) {
    instance.registerFactory<RatePassengerUseCase>(
        () => RatePassengerUseCase(instance()));
  }
}

initBODriversCarsModule() {
  if (!GetIt.I.isRegistered<BusinessOwnerDriversUseCase>()) {
    instance.registerFactory<BusinessOwnerDriversUseCase>(
        () => BusinessOwnerDriversUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<SearchDriversByMobileUseCase>()) {
    instance.registerFactory<SearchDriversByMobileUseCase>(
        () => SearchDriversByMobileUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<SearchDriversByMobileUseCase>()) {
    instance.registerFactory<SearchDriversByMobileUseCase>(
        () => SearchDriversByMobileUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<AddDriverForBOUseCase>()) {
    instance.registerFactory<AddDriverForBOUseCase>(
        () => AddDriverForBOUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BoAssignDriverToTripUseCase>()) {
    instance.registerFactory<BoAssignDriverToTripUseCase>(
        () => BoAssignDriverToTripUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<BOGetPendingDriversUseCase>()) {
    instance.registerFactory<BOGetPendingDriversUseCase>(
        () => BOGetPendingDriversUseCase(instance()));
  }
}

initSearchDriversByMobileModule() {
  if (!GetIt.I.isRegistered<SearchDriversByMobileUseCase>()) {
    instance.registerFactory<SearchDriversByMobileUseCase>(
        () => SearchDriversByMobileUseCase(instance()));
  }
}

initAddDriverForBOModule() {
  if (!GetIt.I.isRegistered<AddDriverForBOUseCase>()) {
    instance.registerFactory<AddDriverForBOUseCase>(
        () => AddDriverForBOUseCase(instance()));
  }
}

initBoLogoutModule() {
  if (!GetIt.I.isRegistered<BoLogoutUseCase>()) {
    instance
        .registerFactory<BoLogoutUseCase>(() => BoLogoutUseCase(instance()));
  }
}

initBoAssignDriverToTripModule() {
  if (!GetIt.I.isRegistered<BoAssignDriverToTripUseCase>()) {
    instance.registerFactory<BoAssignDriverToTripUseCase>(
        () => BoAssignDriverToTripUseCase(instance()));
  }
}

initBOAcceptOfferModule() {
  if (!GetIt.I.isRegistered<BOAcceptOfferUseCase>()) {
    instance.registerFactory<BOAcceptOfferUseCase>(
        () => BOAcceptOfferUseCase(instance()));
  }
}

initBoSuggestNewOfferModule() {
  if (!GetIt.I.isRegistered<BoSuggestNewOfferUseCase>()) {
    instance.registerFactory<BoSuggestNewOfferUseCase>(
        () => BoSuggestNewOfferUseCase(instance()));
  }
}

initUpdateDriverProfileModule() {
  if (!GetIt.I.isRegistered<UpdateDriverProfileUseCase>()) {
    instance.registerFactory<UpdateDriverProfileUseCase>(
        () => UpdateDriverProfileUseCase(instance()));
  }
}

initUpdateBoProfileModule() {
  if (!GetIt.I.isRegistered<UpdateBoProfileUseCase>()) {
    instance.registerFactory<UpdateBoProfileUseCase>(
        () => UpdateBoProfileUseCase(instance()));
  }
}

initDriverRequestsModule() {
  if (!GetIt.I.isRegistered<AddRequestsUseCase>()) {
    instance.registerFactory<AddRequestsUseCase>(
        () => AddRequestsUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<ChangeRequestStatusUseCase>()) {
    instance.registerFactory<ChangeRequestStatusUseCase>(
        () => ChangeRequestStatusUseCase(instance()));
  }
}

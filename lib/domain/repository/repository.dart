import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/allowed_services_model.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';
import 'package:taxi_for_you/domain/model/lookups_model.dart';
import 'package:taxi_for_you/domain/model/persons_vehicle_type_model.dart';
import 'package:taxi_for_you/domain/model/service_type_model.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/add_request_model.dart';
import '../model/country_lookup_model.dart';
import '../model/general_response.dart';
import '../model/generate_otp_model.dart';
import '../model/goods_service_type_model.dart';
import '../model/logout_model.dart';
import '../model/lookupValueModel.dart';
import '../model/requested_drivers_response.dart';
import '../model/service_status_model.dart';
import '../model/trip_details_model.dart';
import '../model/verify_otp_model.dart';

abstract class Repository {
  Future<Either<Failure, List<CountryLookupModel>>> getCountriesLookup();

  Future<Either<Failure, Driver>> login(LoginRequest loginRequest);

  Future<Either<Failure, BusinessOwnerModel>> loginBO(
      LoginRequest loginRequest);

  Future<Either<Failure, List<ServiceTypeModel>>> registrationServiceTypes();

  Future<Either<Failure, List<CarModel>>> carBrandsAndModels();

  Future<Either<Failure, List<CarManufacturerModel>>> carManufacturers(String serviceType);

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, RegistrationResponse>> register(
      RegistrationRequest registrationRequest);

  Future<Either<Failure, RegistrationBOResponse>> registerBO(
      BusinessOwnerModel businessOwnerModel);

  Future<Either<Failure, GenerateOtpModel>> generateOtp(
      GenerateOTPRequest otpRequest);

  Future<Either<Failure, BaseResponse>> verifyOtp(
      VerifyOTPRequest verifyOTPRequest);

  Future<Either<Failure, ServiceRegisterModel>> getServiceStatus(String userId);

  Future<Either<Failure, List<TripDetailsModel>>> getTrips(
      String endPoint,
      String tripTypeModuleId,
      int userId,
      Map<String, dynamic>? dateFilter,
      Map<String, dynamic>? locationFilter,
      Map<String, dynamic>? currentLocation,
      String? sortCriterion,
      String? serviceTypesSelectedByBusinessOwner,
      String? serviceTypesSelectedByDriver);

  Future<Either<Failure, List<TripDetailsModel>>> getMyTrips(
      String endPoint, String tripTypeModuleId, int userId);

  Future<Either<Failure, GeneralResponse>> acceptOffer(int userId, int tripId);

  Future<Either<Failure, GeneralResponse>> addOffer(
      int userId, int tripId, double driverOffer);

  Future<Either<Failure, BaseResponse>> changeTripStatus(
      int userId, int tripId, String tripStatus);

  Future<Either<Failure, TripDetailsModel>> tripSummary(int userId, int tripId);

  Future<Either<Failure, BaseResponse>> ratePassenger(
      int driverId, int tripId, double rate);

  Future<Either<Failure, BaseResponse>> UpdateDriverProfile(
      UpdateDriverProfileRequest updateProfileRequest);

  Future<Either<Failure, BaseResponse>> UpdateBOProfile(
      UpdateBoProfileRequest updateBoProfileRequest);

  Future<Either<Failure, LogoutModel>> logout(LogoutRequest logoutRequest);

  Future<Either<Failure, LogoutModel>> boLogout(LogoutRequest logoutRequest);

  Future<Either<Failure, LookupsModel>> getLookups();

  Future<Either<Failure, List<LookupValueModel>>> getLookupByKey(
      String key, String lang);

  Future<Either<Failure, List<Driver>>> getBODrivers(int businessOwnerId);

  Future<Either<Failure, List<Driver>>> searchDriversByMobile(int mobileNumber);

  Future<Either<Failure, BaseResponse>> addDriverForBO(
      int businessOwnerId, List<int> driverIds);

  Future<Either<Failure, BaseResponse>> boAssignDriverToTrip(
      int businessOwnerId, int driverId, int tripId);

  Future<Either<Failure, BaseResponse>> boAcceptOffer(
      int businessOwnerId, int tripId, int driverId);

  Future<Either<Failure, BaseResponse>> boSuggestNewOffer(
      int businessOwnerId, int tripId, double newSuggestedOffer, int driverId);

  Future<Either<Failure, List<GoodsServiceTypeModel>>> getGoodsServiceTypes();

  Future<Either<Failure, List<PersonsVehicleTypeModel>>>
      getPersonsVehicleTypes();

  Future<Either<Failure, List<AddRequestModel>>> getAddRequests(int driverId);

  Future<Either<Failure, BaseResponse>> changeRequestStatus(
      int acquisitionId, String driverAcquisitionDecision);

  Future<Either<Failure, List<Driver>>> getBOPendingDrivers(
      int businessOwnerId);

  Future<Either<Failure, List<AllowedServiceModel>>>
      getAllowedServicesByUserType(String userType);

  Future<Either<Failure, CoastCalculationModel>> getCostCalculationValues();
}

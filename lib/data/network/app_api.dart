import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:taxi_for_you/domain/model/general_response.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/lookups_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';

import '../../app/constants.dart';
import '../../domain/model/logout_model.dart';
import '../../domain/model/registration_services_response.dart';
import '../../domain/model/service_status_model.dart';
import '../../flavors.dart';
import '../response/responses.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: "")
abstract class AppServiceClient {
  // factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  factory AppServiceClient(Dio dio, {required String baseUrl}) {
    return _AppServiceClient(dio, baseUrl: F.baseUrl);
  }

  @GET(EndPointsConstants.countryLookup)
  Future<BaseResponse> getCountriesLookup();

  @POST(EndPointsConstants.loginPath)
  Future<LoginResponse> login(@Field("login") String login,
      @Field("mobileUserDeviceDTO") Map<String, dynamic> userDeviceDTO);

  @POST(EndPointsConstants.loginPath)
  Future<GeneralResponse> loginBO(@Field("login") String login,
      @Field("mobileUserDeviceDTO") Map<String, dynamic> userDeviceDTO);

  @POST(EndPointsConstants.otpGenerate)
  Future<GenerateOtpModel> generateOtp(
    @Field("mobile") String mobile,
  );

  @POST(EndPointsConstants.otpValidate)
  Future<BaseResponse> verifyOtp(
    @Field("mobile") String mobile,
    @Field("userOtp") String userOtp,
    @Field("generatedOtp") String generatedOtp,
  );

  @GET(EndPointsConstants.personsVehicleTypes)
  Future<RegistrationServicesTypesResponse> registrationServices();

  @GET(EndPointsConstants.carModels)
  Future<BaseResponse> carBrandsAndModels();

  @GET(EndPointsConstants.carManufacturersByServiceType)
  Future<BaseResponse> carManufacturers(
      @Path("serviceType") String serviceType);

  @POST(EndPointsConstants.forgotPassword)
  Future<ForgotPasswordResponse> forgotPassword(@Field("email") String email);

  @POST(EndPointsConstants.registration)
  @MultiPart()
  Future<RegistrationResponse> registerCaptainWithPersonService(
      @Part(name: "firstName") String firstName,
      @Part(name: "lastName") String lastName,
      @Part(name: "mobile") String mobile,
      @Part(name: "email") String email,
      @Part(name: "gender") String gender,
      @Part(name: "dateOfBirth") String dateOfBirth,
      @Part(name: "nationalId") String nationalId,
      @Part(name: "nationalIdExpiryDate") String nationalIdExpiryDate,
      @Part(name: "serviceTypes") String serviceTypeParam,
      @Part(name: "vehicleType.id") String vehicleTypeId,
      @Part(name: "carManufacturer.id") String? carManufacturerId,
      @Part(name: "carModel.id") String? carModelId,
      @Part(name: "vehicleYearOfManufacture") String? vehicleYearOfManufacture,
      @Part(name: "plateNumber") String plateNumber,
      @Part(name: "isAcknowledged") bool isAcknowledged,
      @Part(name: "vehicleDocExpiryDate") String vehicleDocExpiryDate,
      @Part(name: "vehicleOwnerNatIdExpiryDate")
      String vehicleOwnerNatIdExpiryDate,
      @Part(name: "vehicleDriverNatIdExpiryDate")
      String vehicleDriverNatIdExpiryDate,
      @Part(name: "licenseExpiryDate") String licenseExpiryDate,
      @Part(name: "numberOfPassengers") String numberOfPassengers,
      @Part(name: "driverImages") List<File> driverImages,
      @Part(name: "countryCode") String countryCode);

  @POST(EndPointsConstants.registration)
  @MultiPart()
  Future<RegistrationResponse> registerCaptainWithGoodsService(
      @Part(name: "firstName") String firstName,
      @Part(name: "lastName") String lastName,
      @Part(name: "mobile") String mobile,
      @Part(name: "email") String email,
      @Part(name: "gender") String gender,
      @Part(name: "dateOfBirth") String dateOfBirth,
      @Part(name: "nationalId") String nationalId,
      @Part(name: "nationalIdExpiryDate") String nationalIdExpiryDate,
      @Part(name: "serviceTypes") String serviceTypeParam,
      @Part(name: "carManufacturer.id") String? carManufacturerId,
      @Part(name: "carModel.id") String? carModelId,
      @Part(name: "vehicleYearOfManufacture") String? vehicleYearOfManufacture,
      @Part(name: "tankType") String? tankType,
      @Part(name: "tankSize") String? tankSize,
      @Part(name: "canTransportFurniture") bool canTransportFurniture,
      @Part(name: "canTransportGoods") bool canTransportGoods,
      @Part(name: "canTransportFrozen") bool canTransportFrozen,
      @Part(name: "hasWaterTank") bool hasWaterTank,
      @Part(name: "hasOtherTanks") bool hasOtherTanks,
      @Part(name: "hasPacking") bool hasPacking,
      @Part(name: "hasLoading") bool hasLoading,
      @Part(name: "hasAssembly") bool hasAssembly,
      @Part(name: "hasLifting") bool hasLifting,
      @Part(name: "plateNumber") String plateNumber,
      @Part(name: "isAcknowledged") bool isAcknowledged,
      @Part(name: "vehicleDocExpiryDate") String vehicleDocExpiryDate,
      @Part(name: "vehicleOwnerNatIdExpiryDate")
      String vehicleOwnerNatIdExpiryDate,
      @Part(name: "vehicleDriverNatIdExpiryDate")
      String vehicleDriverNatIdExpiryDate,
      @Part(name: "licenseExpiryDate") String licenseExpiryDate,
      @Part(name: "vehicleShape.id") String vehicleShapeId,
      @Part(name: "driverImages") List<File> driverImages,
      @Part(name: "countryCode") String countryCode);

  @POST(EndPointsConstants.boRegistration)
  @MultiPart()
  Future<RegistrationBOResponse> registerBOWithService(
    @Part(name: "firstName") String firstName,
    @Part(name: "lastName") String lastName,
    @Part(name: "mobile") String mobile,
    @Part(name: "email") String email,
    @Part(name: "gender") String gender,
    @Part(name: "dateOfBirth") String dateOfBirth, //
    @Part(name: "entityName") String entityName,
    @Part(name: "taxNumber") String taxNumber,
    @Part(name: "nationalId") String nationalId,
    @Part(name: "nationalIdExpiryDate") String nationalIdExpiryDate,
    @Part(name: "commercialNumber") String commercialNumber,
    @Part(name: "commercialRegisterExpiryDate")
    String commercialRegisterExpiryDate,
    //
    @Part(name: "businessEntityImages") List<File> images,
  );

  @POST(EndPointsConstants.driverRegistrationStatus)
  Future<ServiceRegisterModel> serviceStatus(@Field("userId") String userId);

  @POST("{endpoint}")
  Future<BaseResponse> getTripsByModuleId(
    @Path() String endpoint,
    @Field("tripModelType") String tripModelType,
    @Field("userId") int userId,
    @Field("dateFilter") Map<String, dynamic>? dateFilter,
    @Field("locationFilter") Map<String, dynamic>? locationFilter,
    @Field("currentLocation") Map<String, dynamic>? currentLocation,
    @Field("sortCriterion") String? sortCriterion,
    @Field("serviceTypesSelectedByBusinessOwner")
    String? serviceTypesSelectedByBusinessOwner,
    @Field("serviceTypesSelectedByDriver") String? serviceTypesSelectedByDriver,
  );

  @POST("{endpoint}")
  Future<BaseResponse> getMyTripsByModuleId(
    @Path() String endpoint,
    @Field("tripModelType") String tripModelType,
    @Field("userId") int userId,
    @Field("serviceTypesSelectedByBusinessOwner")
    String? serviceTypesSelectedByBusinessOwner,
  );

  @POST(EndPointsConstants.driverAddOffer)
  Future<GeneralResponse> addOffer(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
    @Field("driverOffer") double driverOffer,
  );

  @PUT(EndPointsConstants.driverAcceptOffer)
  Future<GeneralResponse> acceptOffer(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
  );

  @POST(EndPointsConstants.driverTripSummary)
  Future<GeneralResponse> tripSummary(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
  );

  @GET(EndPointsConstants.lookups)
  Future<LookupsModel> getLookups();

  @POST(EndPointsConstants.logoutPath)
  Future<LogoutModel> logout(
    @Field("refreshToken") String refreshToken,
  );

  @POST(EndPointsConstants.logoutPath)
  Future<LogoutModel> boLogout(
    @Field("refreshToken") String refreshToken,
  );

  @POST(EndPointsConstants.driverChangeTripStatus)
  Future<BaseResponse> changeTripStatus(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
    @Field("tripStatus") String tripStatus,
  );

  @POST(EndPointsConstants.driverRatePassenger)
  Future<BaseResponse> ratePassenger(
    @Field("userId") int driverId,
    @Field("tripId") int tripId,
    @Field("rating") double rateNumber,
  );

  @POST(EndPointsConstants.driverUpdateProfile)
  @MultiPart()
  Future<BaseResponse> updateDriverProfile(
    @Part(name: "id") int? driverId,
    @Part(name: "firstName") String? firstName,
    @Part(name: "lastName") String? lastName,
    @Part(name: "email") String? email,
    @Part(name: "nationalId") String? nationalId,
    @Part(name: "nationalIdExpiryDate") String? nationalIdExpiryDate,
    @Part(name: "plateNumber") String? plateNumber,
    @Part(name: "vehicleDocExpiryDate") String? vehicleDocExpiryDate,
    @Part(name: "vehicleOwnerNatIdExpiryDate")
    String? vehicleOwnerNatIdExpiryDate,
    @Part(name: "vehicleDriverNatIdExpiryDate")
    String? vehicleDriverNatIdExpiryDate,
    @Part(name: "licenseExpiryDate") String? licenseExpiryDate,
    @Part(name: "driverImages") List<File>? driverImages,
  );

  @POST(EndPointsConstants.boUpdateProfile)
  @MultiPart()
  Future<BaseResponse> updateBOProfile(
    @Part(name: "id") int? boId,
    @Part(name: "firstName") String? firstName,
    @Part(name: "lastName") String? lastName,
    @Part(name: "entityName") String? entityName,
    @Part(name: "email") String? email,
    @Part(name: "taxNumber") String? taxNumber,
    @Part(name: "commercialNumber") String? commercialNumber,
    @Part(name: "nationalId") String? nationalId,
    @Part(name: "nationalIdExpiryDate") String? nationalIdExpiryDate,
    @Part(name: "commercialRegisterExpiryDate")
    String? commercialRegisterExpiryDate,
    @Part(name: "businessEntityImages") List<File>? businessEntityImages,
  );

  @POST(EndPointsConstants.boGetMyDrivers)
  Future<BaseResponse> getBODrivers(
    @Field("businessOwnerId") int businessOwnerId,
  );

  @POST(EndPointsConstants.boGetPendingDrivers)
  Future<BaseResponse> getBOPendingDrivers(
    @Field("businessOwnerId") int businessOwnerId,
  );

  @POST(EndPointsConstants.searchDrivers)
  Future<BaseResponse> searchDriversByMobile(
    @Field("mobileNumber") int mobileNumber,
  );

  @POST(EndPointsConstants.boAddDriver)
  Future<BaseResponse> addDriverForBO(
    @Field("businessOwnerId") int businessOwnerId,
    @Field("driverIds") List<int> driverIds,
  );

  @POST(EndPointsConstants.boAssignDriver)
  Future<BaseResponse> boAssignDriverToTrip(
    @Field("businessOwnerId") int businessOwnerId,
    @Field("driverId") int driverId,
    @Field("tripId") int tripId,
  );

  @POST(EndPointsConstants.boSuggestOffer)
  Future<BaseResponse> boSuggestNewOffer(
    @Field("businessOwnerId") int businessOwnerId,
    @Field("tripId") int tripId,
    @Field("newSuggestedOffer") double newSuggestedOffer,
    @Field("driverId") int driverId,
  );

  @POST(EndPointsConstants.boAcceptOffer)
  Future<BaseResponse> boAcceptNewOffer(
    @Field("businessOwnerId") int businessOwnerId,
    @Field("tripId") int tripId,
    @Field("driverId") int driverId,
  );

  @GET(EndPointsConstants.goodsServiceTypes)
  Future<BaseResponse> getGoodsServiceTypes();

  @GET(EndPointsConstants.personsVehicleTypes)
  Future<BaseResponse> getPersonsVehicleTypes();

  @POST(EndPointsConstants.lookupByKey)
  Future<BaseResponse> getLookupByKey(
    @Field("lookupKey") String lookupKey,
    @Field("language") String language,
  );

  @GET(EndPointsConstants.driverAcquisitionRequests)
  Future<BaseResponse> getAddRequests(
    @Path("driverId") String driverId,
  );

  @POST(EndPointsConstants.driverAcquisitionAction)
  Future<BaseResponse> changeRequestStatus(
    @Field("acquisitionId") int acquisitionId,
    @Field("driverAcquisitionDecision") String driverAcquisitionDecision,
  );

  @GET(EndPointsConstants.allowedServicesLookupUT)
  Future<BaseResponse> getAllowedServiceByUserType(
    @Path("userType") String userType,
  );

  @GET(EndPointsConstants.coastCalculationLookupEndpoint)
  Future<BaseResponse> getCoastCalculationValues();
}

import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';
import 'package:taxi_for_you/domain/model/lookupValueModel.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/domain/model/requested_drivers_response.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../app/constants.dart';
import '../../domain/model/general_response.dart';
import '../../domain/model/lookups_model.dart';
import '../../domain/model/registration_services_response.dart';
import '../../presentation/filter_trips/view/helpers/filtration_helper.dart';
import '../network/app_api.dart';
import '../network/requests.dart';
import '../response/responses.dart';

abstract class RemoteDataSource {
  Future<BaseResponse> getCountriesLookup();

  Future<LoginResponse> login(LoginRequest loginRequest);

  Future<GeneralResponse> loginBO(LoginRequest loginRequest);

  Future<GenerateOtpModel> generateOtp(GenerateOTPRequest generateOTPRequest);

  Future<BaseResponse> verifyOtp(VerifyOTPRequest verifyOTPRequest);

  Future<RegistrationServicesTypesResponse> registrationServicesType();

  Future<BaseResponse> carBrandAndModel();

  Future<BaseResponse> carManufacturers(String serviceType);

  Future<RegistrationResponse> registerCaptainWithPersonsService(
      RegistrationRequest registrationRequest);

  Future<RegistrationResponse> registerCaptainWithGoodsService(
      RegistrationRequest registrationRequest);

  Future<RegistrationBOResponse> registerBOWithService(
      BusinessOwnerModel businessOwnerModel);

  Future<ServiceRegisterModel> servicesStatus(String userId);

  Future<BaseResponse> tripsByModuleId(
      String endPoint,
      String tripTypeModuleId,
      int userId,
      Map<String, dynamic>? dateFilter,
      Map<String, dynamic>? locationFilter,
      Map<String, dynamic>? currentLocation,
      String? sortCriterion,
      String? serviceTypesSelectedByBusinessOwner,
      String? serviceTypesSelectedByDriver);

  Future<BaseResponse> myTripsByModuleId(
      String endPoint, String tripTypeModuleId, int userId);

  Future<GeneralResponse> acceptOffer(int userId, int tripId);

  Future<GeneralResponse> addOffer(int userId, int tripId, double driverOffer);

  Future<BaseResponse> changeTripStatus(
      int userId, int tripId, String tripStatus);

  Future<GeneralResponse> tripSummary(int userId, int tripId);

  Future<BaseResponse> ratePassenger(int driverId, int tripId, double rate);

  Future<BaseResponse> updateDriverProfile(
      UpdateDriverProfileRequest updateProfileRequest);

  Future<BaseResponse> updateBOProfile(
      UpdateBoProfileRequest updateBoProfileRequest);

  Future<BaseResponse> getBODrivers(int businessOwnerId);

  Future<BaseResponse> searchDriversByMobile(int mobileNumber);

  Future<LookupsModel> getLookups();

  Future<LogoutModel> logout(LogoutRequest logoutRequest);

  Future<LogoutModel> boLogout(LogoutRequest logoutRequest);

  Future<ForgotPasswordResponse> forgotPassword(String email);

  Future<BaseResponse> addDriverForBO(int businessOwnerId, List<int> driverIds);

  Future<BaseResponse> boAssignDriverForTrip(
      int businessOwnerId, int driverId, int tripId);

  Future<BaseResponse> boAcceptOffer(
      int businessOwnerId, int tripId, int driverId);

  Future<BaseResponse> boSuggestNewOffer(
      int businessOwnerId, int tripId, double newSuggestedOffer, int driverId);

  Future<BaseResponse> getGoodsServiceTypes();

  Future<BaseResponse> getPersonsVehicleTypes();

  Future<BaseResponse> getLookupByKey(String key, String lang);

  Future<BaseResponse> getAddRequestsForDriver(int driverId);

  Future<BaseResponse> changeRequestStatus(
      int acquisitionId, String driverAcquisitionDecision);

  Future<BaseResponse> getBOPendingDrivers(int businessOwnerId);

  Future<BaseResponse> getAllowedServicesByUserType(String userType);

  Future<BaseResponse> getCoastCalculationValues();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.login, loginRequest.mobileUserDeviceDTO);
  }

  @override
  Future<GeneralResponse> loginBO(LoginRequest loginRequest) async {
    return await _appServiceClient.loginBO(
        loginRequest.login, loginRequest.mobileUserDeviceDTO);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    return await _appServiceClient.forgotPassword(email);
  }

  @override
  Future<GenerateOtpModel> generateOtp(
      GenerateOTPRequest generateOTPRequest) async {
    return await _appServiceClient
        .generateOtp(generateOTPRequest.phoneNumberWithCountryCode);
  }

  @override
  Future<BaseResponse> verifyOtp(VerifyOTPRequest verifyOTPRequest) async {
    return await _appServiceClient.verifyOtp(verifyOTPRequest.mobileNumber,
        verifyOTPRequest.otp, verifyOTPRequest.generatedOtp);
  }

  @override
  Future<RegistrationServicesTypesResponse> registrationServicesType() async {
    return await _appServiceClient.registrationServices();
  }

  @override
  Future<BaseResponse> carBrandAndModel() async {
    return await _appServiceClient.carBrandsAndModels();
  }

  @override
  Future<BaseResponse> carManufacturers(String serviceType) async {
    return await _appServiceClient.carManufacturers(serviceType);
  }

  @override
  Future<ServiceRegisterModel> servicesStatus(String userId) async {
    return await _appServiceClient.serviceStatus(userId);
  }

  @override
  Future<LogoutModel> logout(LogoutRequest logoutRequest) async {
    return await _appServiceClient.logout(logoutRequest.refreshToken);
  }

  @override
  Future<RegistrationResponse> registerCaptainWithPersonsService(
      RegistrationRequest registrationRequest) async {
    return await _appServiceClient.registerCaptainWithPersonService(
        registrationRequest.firstName!,
        registrationRequest.lastName!,
        registrationRequest.mobile!,
        registrationRequest.email!,
        registrationRequest.gender!,
        registrationRequest.dateOfBirth!,
        registrationRequest.nationalIdNumber!,
        registrationRequest.nationalIdExpiryDate!,
        registrationRequest.serviceTypeParam!,
        registrationRequest.vehicleTypeId!,
        registrationRequest.carManufacturerTypeId!,
        registrationRequest.carModelId!,
        registrationRequest.vehicleYearOfManufacture!,
        registrationRequest.plateNumber!,
        registrationRequest.isAcknowledged!,
        registrationRequest.vehicleDocExpiryDate!,
        registrationRequest.vehicleOwnerNatIdExpiryDate!,
        registrationRequest.vehicleDriverNatIdExpiryDate!,
        registrationRequest.licenseExpiryDate!,
        registrationRequest.vehicleShapeId.toString(),
        registrationRequest.driverImages!,
        registrationRequest.countryCode.toString());
  }

  @override
  Future<RegistrationResponse> registerCaptainWithGoodsService(
      RegistrationRequest registrationRequest) async {
    return await _appServiceClient.registerCaptainWithGoodsService(
        registrationRequest.firstName!,
        registrationRequest.lastName!,
        registrationRequest.mobile!,
        registrationRequest.email!,
        registrationRequest.gender!,
        registrationRequest.dateOfBirth!,
        registrationRequest.nationalIdNumber!,
        registrationRequest.nationalIdExpiryDate!,
        registrationRequest.serviceTypeParam!,
        // registrationRequest.vehicleTypeId!,
        registrationRequest.carManufacturerTypeId,
        registrationRequest.carModelId,
        registrationRequest.vehicleYearOfManufacture,
        registrationRequest.tankType,
        registrationRequest.tankSize,
        registrationRequest.canTransportFurniture!,
        registrationRequest.canTransportGoods!,
        registrationRequest.canTransportFrozen!,
        registrationRequest.hasWaterTank!,
        registrationRequest.hasOtherTanks!,
        registrationRequest.hasPacking!,
        registrationRequest.hasLoading!,
        registrationRequest.hasAssembly!,
        registrationRequest.hasLifting!,
        registrationRequest.plateNumber!,
        registrationRequest.isAcknowledged!,
        registrationRequest.vehicleDocExpiryDate!,
        registrationRequest.vehicleOwnerNatIdExpiryDate!,
        registrationRequest.vehicleDriverNatIdExpiryDate!,
        registrationRequest.licenseExpiryDate!,
        registrationRequest.vehicleShapeId.toString(),
        registrationRequest.driverImages!,
        registrationRequest.countryCode.toString());
  }

  @override
  Future<RegistrationBOResponse> registerBOWithService(
      BusinessOwnerModel businessOwnerModel) async {
    return await _appServiceClient.registerBOWithService(
        businessOwnerModel.firstName!,
        businessOwnerModel.lastName!,
        businessOwnerModel.mobile!,
        businessOwnerModel.email!,
        businessOwnerModel.gender!,
        businessOwnerModel.dateOfBirth!,
        businessOwnerModel.entityName!,
        businessOwnerModel.taxNumber!,
        businessOwnerModel.nationalId!,
        businessOwnerModel.nationalIdExpiryDate!,
        businessOwnerModel.commercialNumber!,
        businessOwnerModel.commercialRegisterExpiryDate!,
        businessOwnerModel.images!);
  }

  @override
  Future<BaseResponse> tripsByModuleId(
      String endPoint,
      String tripTypeModuleId,
      int userId,
      Map<String, dynamic>? dateFilter,
      Map<String, dynamic>? locationFilter,
      Map<String, dynamic>? currentLocation,
      String? sortCriterion,
      String? serviceTypesSelectedByBusinessOwner,
      String? serviceTypesSelectedByDriver) async {
    return await _appServiceClient.getTripsByModuleId(
        endPoint,
        tripTypeModuleId,
        userId,
        dateFilter,
        locationFilter,
        currentLocation,
        sortCriterion,
        serviceTypesSelectedByBusinessOwner,
        serviceTypesSelectedByDriver);
  }

  @override
  Future<BaseResponse> myTripsByModuleId(
      String endPoint, String tripTypeModuleId, int userId) async {
    return await _appServiceClient.getMyTripsByModuleId(
        endPoint,
        tripTypeModuleId,
        userId,
        endPoint == EndPoints.BusinessOwnerMyTrips
            ? FiltrationHelper().serviceTypesList.join(",")
            : null);
  }

  @override
  Future<GeneralResponse> acceptOffer(int userId, int tripId) async {
    return await _appServiceClient.acceptOffer(userId, tripId);
  }

  @override
  Future<GeneralResponse> addOffer(
      int userId, int tripId, double driverOffer) async {
    return await _appServiceClient.addOffer(userId, tripId, driverOffer);
  }

  @override
  Future<GeneralResponse> tripSummary(int userId, int tripId) async {
    return await _appServiceClient.tripSummary(userId, tripId);
  }

  @override
  Future<LookupsModel> getLookups() async {
    return await _appServiceClient.getLookups();
  }

  @override
  Future<BaseResponse> changeTripStatus(
      int userId, int tripId, String tripStatus) async {
    return await _appServiceClient.changeTripStatus(userId, tripId, tripStatus);
  }

  @override
  Future<BaseResponse> ratePassenger(
      int driverId, int tripId, double rateNumber) async {
    return await _appServiceClient.ratePassenger(driverId, tripId, rateNumber);
  }

  @override
  Future<BaseResponse> updateDriverProfile(
      UpdateDriverProfileRequest updateDriverProfileRequest) async {
    return await _appServiceClient.updateDriverProfile(
        updateDriverProfileRequest.driverId,
        updateDriverProfileRequest.firstName,
        updateDriverProfileRequest.lastName,
        updateDriverProfileRequest.email,
        updateDriverProfileRequest.nationalId,
        updateDriverProfileRequest.nationalIdExpiryDate,
        updateDriverProfileRequest.plateNumber,
        updateDriverProfileRequest.vehicleDocExpiryDate,
        updateDriverProfileRequest.vehicleOwnerNatIdExpiryDate,
        updateDriverProfileRequest.vehicleDriverNatIdExpiryDate,
        updateDriverProfileRequest.licenseExpiryDate,
        updateDriverProfileRequest.driverImages);
  }

  @override
  Future<BaseResponse> updateBOProfile(
      UpdateBoProfileRequest updateBoProfileRequest) async {
    return await _appServiceClient.updateBOProfile(
        updateBoProfileRequest.id,
        updateBoProfileRequest.firstName,
        updateBoProfileRequest.lastName,
        updateBoProfileRequest.entityName,
        updateBoProfileRequest.email,
        updateBoProfileRequest.taxNumber,
        updateBoProfileRequest.commercialNumber,
        updateBoProfileRequest.nationalId,
        updateBoProfileRequest.nationalIdExpiryDate,
        updateBoProfileRequest.commercialRegisterExpiryDate,
        updateBoProfileRequest.businessEntityImages);
  }

  @override
  Future<BaseResponse> getBODrivers(int businessOwnerId) async {
    return await _appServiceClient.getBODrivers(businessOwnerId);
  }

  @override
  Future<BaseResponse> searchDriversByMobile(int mobileNumber) async {
    return await _appServiceClient.searchDriversByMobile(mobileNumber);
  }

  @override
  Future<BaseResponse> addDriverForBO(int businessOwnerId, List<int> driverIds) async {
    return await _appServiceClient.addDriverForBO(businessOwnerId, driverIds);
  }

  @override
  Future<LogoutModel> boLogout(LogoutRequest logoutRequest) async {
    return await _appServiceClient.boLogout(logoutRequest.refreshToken);
  }

  @override
  Future<BaseResponse> boAcceptOffer(
      int businessOwnerId, int tripId, int driverId) async {
    return await _appServiceClient.boAcceptNewOffer(
        businessOwnerId, tripId, driverId);
  }

  @override
  Future<BaseResponse> boAssignDriverForTrip(
      int businessOwnerId, int driverId, int tripId) async {
    return await _appServiceClient.boAssignDriverToTrip(
        businessOwnerId, driverId, tripId);
  }

  @override
  Future<BaseResponse> boSuggestNewOffer(int businessOwnerId, int tripId,
      double newSuggestedOffer, int driverId) async {
    return await _appServiceClient.boSuggestNewOffer(
        businessOwnerId, tripId, newSuggestedOffer, driverId);
  }

  @override
  Future<BaseResponse> getCountriesLookup() async {
    return await _appServiceClient.getCountriesLookup();
  }

  @override
  Future<BaseResponse> getGoodsServiceTypes() async {
    return await _appServiceClient.getGoodsServiceTypes();
  }

  @override
  Future<BaseResponse> getPersonsVehicleTypes() async {
    return await _appServiceClient.getPersonsVehicleTypes();
  }

  @override
  Future<BaseResponse> getLookupByKey(String key, String lang) async {
    return await _appServiceClient.getLookupByKey(key, lang);
  }

  @override
  Future<BaseResponse> getAddRequestsForDriver(int driverId) async {
    return await _appServiceClient.getAddRequests(driverId.toString());
  }

  @override
  Future<BaseResponse> changeRequestStatus(
      int acquisitionId, String driverAcquisitionDecision) async {
    return await _appServiceClient.changeRequestStatus(
        acquisitionId, driverAcquisitionDecision);
  }

  @override
  Future<BaseResponse> getBOPendingDrivers(int businessOwnerId) async {
    return await _appServiceClient.getBOPendingDrivers(businessOwnerId);
  }

  @override
  Future<BaseResponse> getAllowedServicesByUserType(String userType) async {
    return await _appServiceClient.getAllowedServiceByUserType(userType);
  }

  @override
  Future<BaseResponse> getCoastCalculationValues() async {
    return await _appServiceClient.getCoastCalculationValues();
  }
}

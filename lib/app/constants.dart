import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../domain/model/driver_model.dart';
import '../domain/model/models.dart';

class Constants {
  static const String empty = "";
  static const String token = "";
  static const int zero = 0;
  static const int apiTimeOut = 60000;
  static const int onChangeDebounceMilliseconds = 800;
  static const String googleApiKeyAndroid =
      "AIzaSyDudVHh73YAVrXD1CgiJPtIbFbquCmavlA";
  static const String googleApiKeyIos =
      "AIzaSyD8KjkW8eLaDD3qeZIiPPDxqfdK8olftWs";
  static const String uploadDocumentsType = "upload_documents_type";

  static const int imageQualityCompress = 25;

  static const String businessOwnerPhotoImageString = 'business_owner_photo.jpg';
  static const String businessOwnerPhotoDocumentSubstring =
      'business_owner_document_photo_';

  static const String dateFormatterString = "dd/MM/yyyy hh:mm:ss";

  static const int refreshCurrentLocationSeconds = 2;
  static const int refreshEstimatedTimeInSeconds = 5;
  static const int maximumMultiPicImages = 4;

  static const int otpCountTime = 30;
  static const int otpSize = 6;
  static const bool showCursorOtpField = false;

  static const String saudiArabiaIsoCode = 'SA';
  static const String saudiArabiaPhoneCode = '+966';
  static const int saudiArabiaMobileDigits = 9;

  static List<CountryCodes> countryList = [
    CountryCodes(ImageAssets.saudiFlag, AppStrings.saudiCountryCode, 'SA',
        AppStrings.saudiArabia),
    CountryCodes(ImageAssets.egyptFlag, AppStrings.egyptCountryCode, 'EG',
        AppStrings.egypt)
  ];
}

class DriverImagesConstants {
  static const String DRIVER_PHOTO_IMAGE_STRING = 'driver_photo.jpg';
  static const String DRIVER_CAR_PHOTOS_IMAGE_STRING = 'driver-car-photo-';
  static const String CAR_DOCUMENT_FRONT_IMAGE_STRING =
      'Documents.carDocument-front.jpg';
  static const String CAR_DOCUMENT_BACK_IMAGE_STRING =
      'Documents.carDocument-back.jpg';
  static const String DRIVER_NATIONAL_ID_FRONT_IMAGE_STRING =
      'Documents.driverId-front.jpg';
  static const String DRIVER_NATIONAL_ID_BACK_IMAGE_STRING =
      'Documents.driverId-back.jpg';
  static const String DRIVER_LICENSE_FRONT_IMAGE_STRING =
      'Documents.driverLicense-front.jpg';
  static const String DRIVER_LICENSE_BACK_IMAGE_STRING =
      'Documents.driverLicense-back.jpg';
  static const String OWNER_NATIONAL_ID_FRONT_IMAGE_STRING =
      'Documents.ownerId-front.jpg';
  static const String OWNER_NATIONAL_ID_BACK_IMAGE_STRING =
      'Documents.ownerId-back.jpg';
}

class PaymentConstants {
  static const String TESTING_KEY =
      "pk_test_DhoknjKhJ1WgngxDP315TgCYBP3DvBtQA3LZc9Up";
  static const String PRODUCTION_KEY =
      "pk_live_JLF3TS9GDjhLAUkW1bmrzpmLA2X1WZ7EW3tBKJLD";
}

class UserTypeConstants {
  static const String DRIVER = "DRIVER";
  static const String BUSINESS_OWNER = "BUSINESS_OWNER";
}

class EndPointsConstants {
  // Auth
  static const String loginPath = "/api/v1/auth/login";
  static const String refreshToken = "/api/v1/auth/refresh-token";
  static const String logoutPath = "/api/v1/auth/logout";

  // OTP
  static const String otpGenerate = "/otp/generate";
  static const String otpValidate = "/otp/validate";

  // Registration
  static const String registration = "/drivers/register";
  static const String boRegistration = "/bo/register";
  static const String forgotPassword = "/customers/forgotPassword";
  static const String driverRegistrationStatus = "/drivers/registration-status";

  // Driver profile & actions
  static const String driverUpdateProfile = "/drivers/update-profile";
  static const String driverAddOffer = "/drivers/offers/add";
  static const String driverAcceptOffer = "/drivers/offers/accept";
  static const String driverTripSummary = "/drivers/trip-summary";
  static const String driverChangeTripStatus = "/drivers/trips/change-status";
  static const String driverRatePassenger = "/drivers/trips/rate";
  static const String searchDrivers = "/drivers/get-drivers";

  // Business owner profile & actions
  static const String boUpdateProfile = "/bo/update-profile";
  static const String boGetMyDrivers = "/driver-acquisition/get-my-drivers";
  static const String boGetPendingDrivers =
      "/driver-acquisition/get-pending-drivers";
  static const String boAddDriver = "/driver-acquisition/add-driver";
  static const String boAssignDriver = "/driver-acquisition/assign-driver";
  static const String boSuggestOffer = "/driver-acquisition/propose-offer";
  static const String boAcceptOffer = "/driver-acquisition/accept-offer";
  static const String driverAcquisitionRequests =
      "/driver-acquisition/requests/{driverId}";
  static const String driverAcquisitionAction =
      "/driver-acquisition/driver-action";

  // Trip endpoints (dynamic, used with {endpoint} path param)
  static const String driversTrips = "/drivers/offers/select-trip";
  static const String driverMyTrips = "/drivers/offers/select-my-trip";
  static const String businessOwnerTrips = "/driver-acquisition/select-trip";
  static const String businessOwnerMyTrips =
      "/driver-acquisition/select-my-trip";

  // Lookups
  static const String lookups = "/lookups";
  static const String countryLookup = "/lookups/country";
  static const String lookupByKey = "/lookups/by-key";
  static const String goodsServiceTypes = "/drivers/service-types";
  static const String personsVehicleTypes = "/drivers/vehicle-types";
  static const String carModels = "/lookups/car-models";
  static const String carManufacturersByServiceType =
      "/lookups/car-manufacturers?vc={serviceType}";
  static const String carManufacturersByBUS =
      "/lookups/car-manufacturers?vc=BUS";
  static const String carManufacturersBySEDAN =
      "/lookups/car-manufacturers?vc=SEDAN";
  static const String allowedServicesLookupUT =
      "/lookups/allowed-endpoints?ut={userType}";
  static const String allowedServicesLookupDriver =
      "/lookups/allowed-endpoints?ut=DRIVER";
  static const String allowedServicesLookupBusinessOwner =
      "/lookups/allowed-endpoints?ut=BUSINESS_OWNER";
  static const String coastCalculationLookupEndpoint =
      "/lookups/cost-calculations-config";

  static const List<String> cancelTokenApis = [
    logoutPath,
    loginPath,
    otpGenerate,
    refreshToken,
    otpValidate,
    registration,
    boRegistration,
    goodsServiceTypes,
    personsVehicleTypes,
    carModels,
    carManufacturersByServiceType,
    carManufacturersByBUS,
    carManufacturersBySEDAN,
    lookups,
    countryLookup,
    lookupByKey,
    allowedServicesLookupDriver,
    allowedServicesLookupBusinessOwner,
    coastCalculationLookupEndpoint,
  ];
}

class TripTypeConstants {
  static const String carAidType = "CAR_AID";
  static const String drinkWaterType = "DRINK_WATER_TANK";
  static const String frozenType = "FROZEN";
  static const String furnitureType = "FURNITURE";
  static const String goodsType = "GOODS";
  static const String otherTankType = "OTHER_TANK";
  static const String personsType = "PERSONS";
}

class LookupKeys {
  static const String serviceType = "ServiceType";
  static const String tankType = "TankType";
  static const String tankSize = "TankSize";
  static const String yearOfManufacture = "YearOfManufacture";
}

class TripStatusConstants {
  static const String DRAFTED = "DRAFTED";
  static const String TRIP_SUBMITTED = "TRIP_SUBMITTED";
  static const String TRIP_IN_NEGOTIATION = "TRIP_IN_NEGOTIATION";
  static const String WAITING_FOR_PAYMENT = "WAITING_FOR_PAYMENT";
  static const String READY_FOR_TAKEOFF = "READY_FOR_TAKEOFF";
  static const String HEADING_TO_PICKUP_POINT = "HEADING_TO_PICKUP_POINT";
  static const String ARRIVED_TO_PICKUP_POINT = "ARRIVED_TO_PICKUP_POINT";
  static const String HEADING_TO_DESTINATION = "HEADING_TO_DESTINATION";
  static const String TRIP_COMPLETED = "TRIP_COMPLETED";
  static const String TRIP_CANCELLED = "TRIP_CANCELLED";
}


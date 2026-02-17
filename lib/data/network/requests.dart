import 'dart:io';

class LoginRequest {
  String login;
  Map<String, dynamic> mobileUserDeviceDTO;

  LoginRequest(this.login, this.mobileUserDeviceDTO);
}

class RegisterRequest {
  String serviceType;
  String serviceTypeCapacity;
  int plateNumber;
  String carBrandAndModel;
  String notes;
  String carDocumentImage;
  String carOwnerLicenseImage;
  String carOwnerIdentityCardImage;
  String carDriverIdentityCardImage;

  RegisterRequest(
      this.serviceType,
      this.serviceTypeCapacity,
      this.plateNumber,
      this.carBrandAndModel,
      this.notes,
      this.carDocumentImage,
      this.carOwnerLicenseImage,
      this.carOwnerIdentityCardImage,
      this.carDriverIdentityCardImage);
}

class GenerateOTPRequest {
  String phoneNumberWithCountryCode;

  GenerateOTPRequest(this.phoneNumberWithCountryCode);
}

class VerifyOTPRequest {
  String otp;
  String mobileNumber;
  String generatedOtp;

  VerifyOTPRequest(this.otp, this.mobileNumber, this.generatedOtp);
}

class LogoutRequest {
  String refreshToken;

  LogoutRequest(this.refreshToken);
}

class UpdateDriverProfileRequest {
  int driverId;
  String firstName;
  String lastName;
  String email;
  String nationalId;
  String nationalIdExpiryDate;
  String plateNumber;
  String vehicleDocExpiryDate;
  String vehicleOwnerNatIdExpiryDate;
  String vehicleDriverNatIdExpiryDate;
  String licenseExpiryDate;
  List<File>? driverImages;

  UpdateDriverProfileRequest(
      {required this.driverId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.nationalId,
      required this.nationalIdExpiryDate,
      required this.plateNumber,
      required this.vehicleDocExpiryDate,
      required this.vehicleOwnerNatIdExpiryDate,
      required this.vehicleDriverNatIdExpiryDate,
      required this.licenseExpiryDate,
      required this.driverImages});
}

class UpdateBoProfileRequest {
  int? id;
  String? firstName;
  String? lastName;
  String? entityName;
  String? email;
  String? taxNumber;
  String? commercialNumber;
  String? nationalId;
  List<File>? businessEntityImages;
  String? nationalIdExpiryDate;
  String? commercialRegisterExpiryDate;

  UpdateBoProfileRequest(
      this.id,
      this.firstName,
      this.lastName,
      this.entityName,
      this.email,
      this.taxNumber,
      this.commercialNumber,
      this.nationalId,
      this.businessEntityImages,
      this.nationalIdExpiryDate,
      this.commercialRegisterExpiryDate);
}

class AcceptOfferRequest {
  int userId;
  int tripId;

  AcceptOfferRequest(this.userId, this.tripId);
}

class AddOfferRequest {
  int userId;
  int tripId;
  int driverOffer;

  AddOfferRequest(this.userId, this.tripId, this.driverOffer);
}

class TripSummaryRequest {
  int userId;
  int tripId;

  TripSummaryRequest(this.userId, this.tripId);
}

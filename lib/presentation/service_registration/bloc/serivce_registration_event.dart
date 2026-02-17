part of 'serivce_registration_bloc.dart';

@immutable
abstract class ServiceRegistrationEvent {}

class GetServiceTypes extends ServiceRegistrationEvent {
  GetServiceTypes();
}

class GetGoodsServiceTypes extends ServiceRegistrationEvent {
  GetGoodsServiceTypes();
}

class GetPersonsVehicleTypes extends ServiceRegistrationEvent {
  GetPersonsVehicleTypes();
}

class GetTankTypes extends ServiceRegistrationEvent {
  GetTankTypes();
}

class GetTankSizes extends ServiceRegistrationEvent {
  GetTankSizes();
}

class GetCarBrandAndModel extends ServiceRegistrationEvent {
  GetCarBrandAndModel();
}

class GetCarManufacture extends ServiceRegistrationEvent {
  String selectedServiceType;

  GetCarManufacture({required this.selectedServiceType});
}

class GetYearsOfModel extends ServiceRegistrationEvent {
  GetYearsOfModel();
}

class RegisterCaptainWithService extends ServiceRegistrationEvent {
  RegisterCaptainWithService();
}

class RegisterBOWithService extends ServiceRegistrationEvent {
  final BusinessOwnerModel businessOwnerModel;

  RegisterBOWithService({required this.businessOwnerModel});
}

class addCaptainData extends ServiceRegistrationEvent {
  XFile? captainPhoto;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? birthDate;
  String? nationalIdNumber;
  String? nationalIdExpiryDate;
  bool? agreeWithTerms;

  addCaptainData(
      {this.captainPhoto,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.birthDate,
      this.nationalIdNumber,
      this.nationalIdExpiryDate,
      this.agreeWithTerms});
}

class NavigateToUploadDocument extends ServiceRegistrationEvent {
  final DocumentType documentTypeFront;
  final DocumentType documentTypeBack;
  final Documents document;

  NavigateToUploadDocument(
    this.documentTypeFront,
    this.documentTypeBack,
    this.document,
  );
}

class SetDocumentData extends ServiceRegistrationEvent {
  final DocumentType documentType;
  final XFile frontImage;
  final XFile backImage;
  final String expireDate;

  SetDocumentData(
      this.documentType, this.frontImage, this.backImage, this.expireDate);
}

class ChangeDocumentStatus extends ServiceRegistrationEvent {
  Documents document;
  DocumentData documentData;

  ChangeDocumentStatus(this.document, this.documentData);
}

class SelectToUploadEvent extends ServiceRegistrationEvent {
  final Documents document;

  SelectToUploadEvent(this.document);
}

class SetDocumentForView extends ServiceRegistrationEvent {
  Documents? document;
  XFile? frontImage;
  XFile? backImage;
  String? expireDate;
  int documentPicked;

  SetDocumentForView(
      {this.document,
      this.frontImage,
      this.backImage,
      this.expireDate,
      required this.documentPicked});
}

class SetCaptainData extends ServiceRegistrationEvent {
  XFile captainPhoto;
  String mobileNumber;
  String firstName;
  String lastName;
  String? email;
  String gender;
  String birthDate;
  String nationalIdNumber;
  String nationalIdExpiryDate;

  SetCaptainData(
      this.captainPhoto,
      this.mobileNumber,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.birthDate,
      this.nationalIdNumber,
      this.nationalIdExpiryDate);
}

class SetFirstStepData extends ServiceRegistrationEvent {
  final String serviceTypeParam;
  final String vehicleTypeId;
  final String vehicleShapeId;
  String? tankType;
  String? tankSize;
  final int serviceModelId;
  final AdditionalServicesModel additionalServicesModel;

  SetFirstStepData(
    this.serviceTypeParam,
    this.vehicleTypeId,
    this.vehicleShapeId,
    this.serviceModelId,
    this.additionalServicesModel,
    this.tankType,
    this.tankSize,
  );
}

class SetSecondStepData extends ServiceRegistrationEvent {
  String? carManufacturerId;
  String? vehicleYearOfManufacture;
  String? carModelId;
  final String plateNumber;
  final String carNotes;
  final List<XFile> carPhotos;
  DocumentData carDocumentPhotos;
  DocumentData carDriverLicensePhotos;
  DocumentData carDriverIdPhotos;
  DocumentData carOwnerIdPhotos;

  SetSecondStepData(
      this.carManufacturerId,
      this.vehicleYearOfManufacture,
      this.carModelId,
      this.plateNumber,
      this.carNotes,
      this.carPhotos,
      this.carDocumentPhotos,
      this.carDriverLicensePhotos,
      this.carDriverIdPhotos,
      this.carOwnerIdPhotos);
}

class RegisterCaptainEvent extends ServiceRegistrationEvent {}

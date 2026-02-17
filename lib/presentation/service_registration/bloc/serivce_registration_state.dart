part of 'serivce_registration_bloc.dart';

@immutable
abstract class ServiceRegistrationState {}

class ServiceRegistrationInitial extends ServiceRegistrationState {}

class ServiceRegistrationLoading extends ServiceRegistrationState {}

class ServiceRegistrationSuccess extends ServiceRegistrationState {}

class ServiceBORegistrationSuccess extends ServiceRegistrationState {}

class TankTypesSuccess extends ServiceRegistrationState {
  List<LookupValueModel> tankValues;

  TankTypesSuccess(this.tankValues);
}

class TankSizeSuccess extends ServiceRegistrationState {
  List<LookupValueModel> tankSizeValues;

  TankSizeSuccess(this.tankSizeValues);
}

class CaptainDataIsValid extends ServiceRegistrationState {}

class CaptainDataIsNotValid extends ServiceRegistrationState {}

class ServiceRegistrationFail extends ServiceRegistrationState {
  final String message;

  ServiceRegistrationFail(this.message);
}

class ServicesTypesSuccess extends ServiceRegistrationState {
  final List<ServiceTypeModel> serviceTypeModelList;

  ServicesTypesSuccess(this.serviceTypeModelList);
}

class GoodsServicesTypesSuccess extends ServiceRegistrationState {
  final List<GoodsServiceTypeModel> goodsServiceTypesList;

  GoodsServicesTypesSuccess(this.goodsServiceTypesList);
}

class PersonsVehicleTypesSuccess extends ServiceRegistrationState {
  final List<PersonsVehicleTypeModel> personsVehicleTypesList;

  PersonsVehicleTypesSuccess(this.personsVehicleTypesList);
}

class ServicesTypesFail extends ServiceRegistrationState {
  final String message;

  ServicesTypesFail(this.message);
}

class CarBrandsAndModelsSuccess extends ServiceRegistrationState {
  final List<CarModel> carModelList;

  CarBrandsAndModelsSuccess(this.carModelList);
}

class CarsManuSuccess extends ServiceRegistrationState {
  final List<CarManufacturerModel> carManuList;

  CarsManuSuccess(this.carManuList);
}

class YearOfManuSuccess extends ServiceRegistrationState {
  final List<LookupValueModel> yearOfManufactureList;

  YearOfManuSuccess(this.yearOfManufactureList);
}

class CarBrandsAndModelsFail extends ServiceRegistrationState {
  final String message;

  CarBrandsAndModelsFail(this.message);
}

class DocumentDataState extends ServiceRegistrationState {
  final String documentPhotoFrontTitle;
  final String documentPhotoBackTitle;
  final String documentExpirationDateTitle;
  XFile? frontImageFile;
  XFile? backImageFile;
  String? expiryDate;

  // Documents document;

  DocumentDataState(
      this.documentPhotoFrontTitle,
      this.documentPhotoBackTitle,
      this.documentExpirationDateTitle,
      this.frontImageFile,
      this.backImageFile,
      this.expiryDate);
}

class IsDataIsValidState extends ServiceRegistrationState {
  bool? isCarDocumentValid;
  bool? isDriverIdValid;
  bool? isDriverLicValid;
  bool? isOwnerIdValid;
  bool? isAllDataValid;

  IsDataIsValidState(
      {this.isCarDocumentValid,
      this.isDriverIdValid,
      this.isDriverLicValid,
      this.isOwnerIdValid,
      this.isAllDataValid});
}

class DocumentStatusState extends ServiceRegistrationState {
  final bool isCarDocumentValid;
  final bool isCarDriverIdDocumentValid;
  final bool isCarDriverLicenseValid;
  final bool isCarOwnerIdValid;
  final bool isAllDataValid;

  DocumentStatusState(
      this.isCarDocumentValid,
      this.isCarDriverIdDocumentValid,
      this.isCarDriverLicenseValid,
      this.isCarOwnerIdValid,
      this.isAllDataValid);
}

class DocumentPickedImage extends ServiceRegistrationState {
  XFile? frontImageFile;
  XFile? backImageFile;
  String? expiryDate;
  int pickedImage;

  DocumentPickedImage(
      {this.frontImageFile,
      this.backImageFile,
      this.expiryDate,
      required this.pickedImage});
}

class UploadDocumentDataIfExists extends ServiceRegistrationState {
  XFile? frontImageFile;
  XFile? backImageFile;
  String? expiryDate;

  UploadDocumentDataIfExists(
      this.frontImageFile, this.backImageFile, this.expiryDate);
}

class captainDataAddedState extends ServiceRegistrationState {
  RegistrationRequest registrationRequest;

  captainDataAddedState(this.registrationRequest);
}

class FirstStepDataAddedState extends ServiceRegistrationState {
  RegistrationRequest registrationRequest;

  FirstStepDataAddedState(this.registrationRequest);
}

class SecondStepDataAddedState extends ServiceRegistrationState {}

class CarDocumentValid extends ServiceRegistrationState {
  final DocumentData carDocument;

  CarDocumentValid(this.carDocument);
}

class driverIdValid extends ServiceRegistrationState {
  final DocumentData driverIdDocument;

  driverIdValid(this.driverIdDocument);
}

class ownerIdValid extends ServiceRegistrationState {
  final DocumentData ownerIdDocument;

  ownerIdValid(this.ownerIdDocument);
}

class driverLicenseValid extends ServiceRegistrationState {
  final DocumentData driverLicenseDocument;

  driverLicenseValid(this.driverLicenseDocument);
}

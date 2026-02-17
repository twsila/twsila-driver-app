part of 'update_driver_bloc.dart';

@immutable
abstract class UpdateDriverEvent {}

class splitAndOrganizeImagesList extends UpdateDriverEvent {
  final List<DriverImage> driverImagesList;

  splitAndOrganizeImagesList({required this.driverImagesList});
}
class EditDriverProfileDataEvent extends UpdateDriverEvent {
  final String firstName;
  final String lastName;
  final String email;
  final File? profilePhoto;

  final String nationalIdNumber;
  final String plateNumber;
  List<String>? carImagesFromFile;
  List<String>? carDocumentsImagesFromFile;
  List<String>? driverLicenseImagesFromFile;
  List<String>? driverNationalIdImagesFromFile;
  List<String>? ownerNationalIdImagesFromFile;

  final String carDocumentExpiryDate;
  final String driverLicenseExpiryDate;
  final String driverNationalIdExpiryDate;
  final String ownerNationalIdExpiryDate;

  EditDriverProfileDataEvent(
      {required this.firstName,
        required this.lastName,
        required this.email,
        this.profilePhoto,
        required this.nationalIdNumber,
        required this.plateNumber,
        this.carImagesFromFile,
        this.carDocumentsImagesFromFile,
        this.driverLicenseImagesFromFile,
        this.driverNationalIdImagesFromFile,
        this.ownerNationalIdImagesFromFile,
        required this.carDocumentExpiryDate,
        required this.driverLicenseExpiryDate,
        required this.driverNationalIdExpiryDate,
        required this.ownerNationalIdExpiryDate});
}
part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileDataEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final File? profilePhoto;

  final String nationalIdNumber;
  final String plateNumber;
  List<File>? carImages;
  List<File>? carDocumentsImages;
  List<File>? driverLicenseImages;
  List<File>? driverNationalIdImages;
  List<File>? ownerNationalIdImages;

  final String carDocumentExpiryDate;
  final String driverLicenseExpiryDate;
  final String driverNationalIdExpiryDate;
  final String ownerNationalIdExpiryDate;

  EditProfileDataEvent(
      {required this.firstName,
      required this.lastName,
      required this.email,
      this.profilePhoto,
      required this.nationalIdNumber,
      required this.plateNumber,
      this.carImages,
      this.carDocumentsImages,
      this.driverLicenseImages,
      this.driverNationalIdImages,
      this.ownerNationalIdImages,
      required this.carDocumentExpiryDate,
      required this.driverLicenseExpiryDate,
      required this.driverNationalIdExpiryDate,
      required this.ownerNationalIdExpiryDate});
}

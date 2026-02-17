part of 'update_bo_bloc.dart';

@immutable
abstract class UpdateBoEvent {}

class splitAndOrganizeImagesList extends UpdateBoEvent {
  final List<DriverImage> boImagesList;

  splitAndOrganizeImagesList({required this.boImagesList});
}

class EditBoProfileDataEvent extends UpdateBoEvent {
  int? id;
  String? firstName;
  String? lastName;
  String? entityName;
  String? email;
  String? taxNumber;
  String? commercialNumber;
  String? nationalId;

  List<String>? businessEntityImagesFromFile;
  String? nationalIdExpiryDate;
  String? commercialRegisterExpiryDate;

  EditBoProfileDataEvent(
      this.id,
      this.firstName,
      this.lastName,
      this.entityName,
      this.email,
      this.taxNumber,
      this.commercialNumber,
      this.nationalId,
      this.businessEntityImagesFromFile,
      this.nationalIdExpiryDate,
      this.commercialRegisterExpiryDate);
}

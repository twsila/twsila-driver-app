part of 'update_driver_bloc.dart';

@immutable
abstract class UpdateDriverState {}

class UpdateDriverInitial extends UpdateDriverState {}

class UpdateDriverLoading extends UpdateDriverState {}

class driverOptimizedImagesSuccessState extends UpdateDriverState {
  List<String> carImageUrls;
  List<String> carDocumentsImageUrls;
  List<String> driverLicenseImageUrls;
  List<String> driverNationalIdImageUrls;
  List<String> ownerNationalIdImageUrls;

  driverOptimizedImagesSuccessState(
      this.carImageUrls,
      this.carDocumentsImageUrls,
      this.driverLicenseImageUrls,
      this.driverNationalIdImageUrls,
      this.ownerNationalIdImageUrls);
}

class UpdateDriverSuccess extends UpdateDriverState {}

class UpdateDriverFail extends UpdateDriverState {
  final String message;
  final String errorCode;

  UpdateDriverFail(this.message, this.errorCode);
}

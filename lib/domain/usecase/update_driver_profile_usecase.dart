import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/repository/repository.dart';
import 'package:taxi_for_you/domain/usecase/base_usecase.dart';

import '../../data/network/failure.dart';

class UpdateDriverProfileUseCase
    implements BaseUseCase<UpdateDriverProfileUseCaseInput, BaseResponse> {
  final Repository _repository;

  UpdateDriverProfileUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      UpdateDriverProfileUseCaseInput input) async {
    return await _repository.UpdateDriverProfile(UpdateDriverProfileRequest(
        driverId: input.driverId,
        firstName: input.firstName,
        lastName: input.lastName,
        email: input.email,
        nationalId: input.nationalId,
        nationalIdExpiryDate: input.nationalIdExpiryDate,
        plateNumber: input.plateNumber,
        vehicleDocExpiryDate: input.vehicleDocExpiryDate,
        vehicleOwnerNatIdExpiryDate: input.vehicleOwnerNatIdExpiryDate,
        vehicleDriverNatIdExpiryDate: input.vehicleDriverNatIdExpiryDate,
        licenseExpiryDate: input.licenseExpiryDate,
        driverImages: input.driverImages));
  }
}

class UpdateDriverProfileUseCaseInput {
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

  UpdateDriverProfileUseCaseInput(
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

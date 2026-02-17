import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegistrationUseCase
    implements BaseUseCase<RegistrationUseCaseInput, RegistrationResponse> {
  final Repository _repository;

  RegistrationUseCase(this._repository);

  @override
  Future<Either<Failure, RegistrationResponse>> execute(
      RegistrationUseCaseInput input) async {
    return await _repository.register(RegistrationRequest(
        input.firstName,
        input.lastName,
        input.mobile,
        input.email,
        input.gender,
        input.dateOfBirth,
        input.nationalIdNumber,
        input.nationalIdExpiryDate,
        input.driverServiceType,
        input.vehicleTypeId,
        input.carManufacturerTypeId,
        input.carModelId,
        input.vehicleYearOfManufacture,
        input.tankType,
        input.tankSize,
        input.carNotes,
        input.countryCode,
        null,
        //car images can be null cause we use it in view only
        input.plateNumber,
        input.driverImages,
        input.canTransportFurniture,
        input.canTransportGoods,
        input.canTransportFrozen,
        input.hasWaterTank,
        input.hasOtherTanks,
        input.hasPacking,
        input.hasLoading,
        input.hasAssembly,
        input.hasLifting,
        input.isAcknowledged,
        input.vehicleDocExpiryDate,
        input.vehicleOwnerNatIdExpiryDate,
        input.vehicleDriverNatIdExpiryDate,
        input.licenseExpiryDate,
        vehicleShapeId: input.vehicleShapeId,
        serviceModelId: input.serviceModelId));
  }
}

class RegistrationUseCaseInput {
  String firstName;
  String lastName;
  String mobile;
  String? email;
  String gender;
  String dateOfBirth;
  String nationalIdNumber;
  String nationalIdExpiryDate;
  String driverServiceType;
  String vehicleTypeId;
  String? carManufacturerTypeId;
  String? carModelId;
  String? vehicleYearOfManufacture;
  String? tankType;
  String? tankSize;
  String carNotes;
  String countryCode;
  String plateNumber;
  String vehicleDocExpiryDate;
  String vehicleOwnerNatIdExpiryDate;
  String vehicleDriverNatIdExpiryDate;
  String licenseExpiryDate;
  List<File> driverImages;

  String? vehicleShapeId;
  String? numberOfPassengersId;

  bool? canTransportFurniture;
  bool? canTransportGoods;
  bool? canTransportFrozen;
  bool? hasWaterTank;
  bool? hasOtherTanks;
  bool? hasPacking;
  bool? hasLoading;
  bool? hasAssembly;
  bool? hasLifting;

  bool isAcknowledged;

  int? serviceModelId;

  RegistrationUseCaseInput(
      {required this.firstName,
      required this.lastName,
      required this.mobile,
      this.email,
      required this.gender,
      required this.dateOfBirth,
      required this.nationalIdNumber,
      required this.nationalIdExpiryDate,
      required this.driverServiceType,
      required this.vehicleTypeId,
       this.carManufacturerTypeId,
       this.carModelId,
       this.vehicleYearOfManufacture,
      this.tankType,
      this.tankSize,
      required this.carNotes,
      required this.plateNumber,
      required this.driverImages,
      required this.vehicleDocExpiryDate,
      required this.vehicleOwnerNatIdExpiryDate,
      required this.vehicleDriverNatIdExpiryDate,
      required this.licenseExpiryDate,
      this.numberOfPassengersId,
      this.vehicleShapeId,
      required this.countryCode,
      this.canTransportFurniture = false,
      this.canTransportGoods = false,
      this.canTransportFrozen = false,
      this.hasWaterTank = false,
      this.hasOtherTanks = false,
      this.hasPacking = false,
      this.hasLoading = false,
      this.hasAssembly = false,
      this.hasLifting = false,
      required this.isAcknowledged,
      this.serviceModelId});
}

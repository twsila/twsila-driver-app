import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/repository/repository.dart';
import 'package:taxi_for_you/domain/usecase/base_usecase.dart';

import '../../data/network/failure.dart';

class UpdateBoProfileUseCase
    implements BaseUseCase<UpdateBoProfileUseCaseInput, BaseResponse> {
  final Repository _repository;

  UpdateBoProfileUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      UpdateBoProfileUseCaseInput input) async {
    return await _repository.UpdateBOProfile(UpdateBoProfileRequest(
        input.id,
        input.firstName,
        input.lastName,
        input.entityName,
        input.email,
        input.taxNumber,
        input.commercialNumber,
        input.nationalId,
        input.businessEntityImages,
        input.nationalIdExpiryDate,
        input.commercialRegisterExpiryDate));
  }
}

class UpdateBOProfileUseCase
    implements BaseUseCase<UpdateBoProfileUseCaseInput, BaseResponse> {
  final Repository _repository;

  UpdateBOProfileUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      UpdateBoProfileUseCaseInput input) async {
    return await _repository.UpdateBOProfile(UpdateBoProfileRequest(
        input.id,
        input.firstName,
        input.lastName,
        input.entityName,
        input.email,
        input.taxNumber,
        input.commercialNumber,
        input.nationalId,
        input.businessEntityImages,
        input.nationalIdExpiryDate,
        input.commercialRegisterExpiryDate));
  }
}

class UpdateBoProfileUseCaseInput {
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

  UpdateBoProfileUseCaseInput(
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

import 'package:dartz/dartz.dart';

import 'package:taxi_for_you/data/network/failure.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';

import '../repository/repository.dart';
import 'base_usecase.dart';

class BOGetPendingDriversUseCase
    implements
        BaseUseCase<BOGetPendingDriversUseCaseInput, List<Driver>> {
  final Repository _repository;

  BOGetPendingDriversUseCase(this._repository);

  @override
  Future<Either<Failure, List<Driver>>> execute(
      BOGetPendingDriversUseCaseInput input) {
    return _repository.getBOPendingDrivers(input.businessOwnerId);
  }
}

class BOGetPendingDriversUseCaseInput {
  int businessOwnerId;

  BOGetPendingDriversUseCaseInput(this.businessOwnerId);
}

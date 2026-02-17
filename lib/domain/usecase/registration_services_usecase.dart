import 'package:dartz/dartz.dart';

import 'package:taxi_for_you/data/network/failure.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../model/service_type_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegistrationServiceUseCase
    implements
        BaseUseCase<RegistrationServiceUseCaseInput, List<ServiceTypeModel>> {
  final Repository _repository;

  RegistrationServiceUseCase(this._repository);

  @override
  Future<Either<Failure, List<ServiceTypeModel>>> execute(
      RegistrationServiceUseCaseInput input) {
    return _repository.registrationServiceTypes();
  }
}

class RegistrationServiceUseCaseInput {
  RegistrationServiceUseCaseInput();
}

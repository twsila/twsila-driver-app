import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/allowed_services_model.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class AllowedServicesUseCase
    implements
        BaseUseCase<AllowedServicesUseCaseInput, List<AllowedServiceModel>> {
  final Repository _repository;

  AllowedServicesUseCase(this._repository);

  @override
  Future<Either<Failure, List<AllowedServiceModel>>> execute(
      AllowedServicesUseCaseInput input) async {
    return await _repository.getAllowedServicesByUserType(input.userType);
  }
}

class AllowedServicesUseCaseInput {
  String userType;

  AllowedServicesUseCaseInput(this.userType);
}

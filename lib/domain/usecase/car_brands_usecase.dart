import 'package:dartz/dartz.dart';

import 'package:taxi_for_you/data/network/failure.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../model/service_type_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class CarBrandsAndModelsUseCase
    implements
        BaseUseCase<CarBrandsAndModelsUseCaseInput, List<CarModel>> {
  final Repository _repository;

  CarBrandsAndModelsUseCase(this._repository);

  @override
  Future<Either<Failure, List<CarModel>>> execute(
      CarBrandsAndModelsUseCaseInput input) {
    return _repository.carBrandsAndModels();
  }
}

class CarBrandsAndModelsUseCaseInput {
  CarBrandsAndModelsUseCaseInput();
}

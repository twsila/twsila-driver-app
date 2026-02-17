import 'package:dartz/dartz.dart';

import 'package:taxi_for_you/data/network/failure.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../model/service_type_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class CarManufacturerUseCase
    implements
        BaseUseCase<CarManufacturerUseCaseInput, List<CarManufacturerModel>> {
  final Repository _repository;

  CarManufacturerUseCase(this._repository);

  @override
  Future<Either<Failure, List<CarManufacturerModel>>> execute(
      CarManufacturerUseCaseInput input) {
    return _repository.carManufacturers(input.serviceType);
  }
}

class CarManufacturerUseCaseInput {
  String serviceType;
  CarManufacturerUseCaseInput({required this.serviceType});
}

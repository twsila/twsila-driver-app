import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/goods_service_type_model.dart';

import '../../data/network/failure.dart';
import '../model/lookups_model.dart';
import '../model/persons_vehicle_type_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class PersonsVehicleTypesUseCase
    implements
        BaseUseCase<PersonsVehicleTypesUseCaseInput,
            List<PersonsVehicleTypeModel>> {
  final Repository _repository;

  PersonsVehicleTypesUseCase(this._repository);

  @override
  Future<Either<Failure, List<PersonsVehicleTypeModel>>> execute(
      PersonsVehicleTypesUseCaseInput input) async {
    return await _repository.getPersonsVehicleTypes();
  }
}

class PersonsVehicleTypesUseCaseInput {}

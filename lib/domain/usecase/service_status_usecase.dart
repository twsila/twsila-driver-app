
import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class ServiceStatusUseCase implements BaseUseCase<ServiceStatusInput, ServiceRegisterModel> {
  final Repository _repository;

  ServiceStatusUseCase(this._repository);

  @override
  Future<Either<Failure, ServiceRegisterModel>> execute(
      ServiceStatusInput input) async {
    return await _repository.getServiceStatus(input.userId);
  }
}

class ServiceStatusInput {
  String userId;

  ServiceStatusInput(this.userId);
}

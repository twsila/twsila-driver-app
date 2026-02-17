
import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/add_request_model.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class AddRequestsUseCase
    implements BaseUseCase<AddRequestsUseCaseInput, List<AddRequestModel>> {
  final Repository _repository;

  AddRequestsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AddRequestModel>>> execute(
      AddRequestsUseCaseInput input) async {
    return await _repository.getAddRequests(input.driverId);
  }
}

class AddRequestsUseCaseInput {
  int driverId;

  AddRequestsUseCaseInput(this.driverId);
}

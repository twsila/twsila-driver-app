import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class AddDriverForBOUseCase
    implements BaseUseCase<AddDriverForBOUseCaseInput, BaseResponse> {
  final Repository _repository;

  AddDriverForBOUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      AddDriverForBOUseCaseInput input) async {
    return await _repository.addDriverForBO(
        input.businessOwnerId, input.driverIds);
  }
}

class AddDriverForBOUseCaseInput {
  int businessOwnerId;
  List<int> driverIds;

  AddDriverForBOUseCaseInput(this.businessOwnerId, this.driverIds);
}


import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/add_request_model.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class ChangeRequestStatusUseCase
    implements BaseUseCase<ChangeRequestStatusUseCaseInput, BaseResponse> {
  final Repository _repository;

  ChangeRequestStatusUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      ChangeRequestStatusUseCaseInput input) async {
    return await _repository.changeRequestStatus(input.acquisitionId,input.driverAcquisitionDecision);
  }
}

class ChangeRequestStatusUseCaseInput {
  int acquisitionId;
  String driverAcquisitionDecision;

  ChangeRequestStatusUseCaseInput(this.acquisitionId,this.driverAcquisitionDecision);
}

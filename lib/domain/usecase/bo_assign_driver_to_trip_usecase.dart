import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class BoAssignDriverToTripUseCase
    implements BaseUseCase<BoAssignDriverToTripUseCaseInput, BaseResponse> {
  final Repository _repository;

  BoAssignDriverToTripUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      BoAssignDriverToTripUseCaseInput input) async {
    return await _repository.boAssignDriverToTrip(
        input.businessOwnerId, input.driverId,input.tripId);
  }
}

class BoAssignDriverToTripUseCaseInput {
  int businessOwnerId;
  int driverId;
  int tripId;

  BoAssignDriverToTripUseCaseInput(
      this.businessOwnerId, this.driverId, this.tripId);
}

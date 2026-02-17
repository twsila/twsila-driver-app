import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RatePassengerUseCase
    implements BaseUseCase<RatePassengerUseCaseInput, BaseResponse> {
  final Repository _repository;

  RatePassengerUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      RatePassengerUseCaseInput input) {
    return _repository.ratePassenger(input.driverId,input.tripId,input.ratingNumber);
  }
}

class RatePassengerUseCaseInput {
  int driverId;
  int tripId;
  double ratingNumber;

  RatePassengerUseCaseInput(this.driverId, this.tripId, this.ratingNumber);
}

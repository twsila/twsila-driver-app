import 'package:dartz/dartz.dart';

import 'package:taxi_for_you/data/network/failure.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../model/service_type_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class ChangeTripStatusUseCase
    implements BaseUseCase<ChangeTripStatusUseCaseInput, BaseResponse> {
  final Repository _repository;

  ChangeTripStatusUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      ChangeTripStatusUseCaseInput input) {
    return _repository.changeTripStatus(
        input.userId, input.tripId, input.tripStatus);
  }
}

class ChangeTripStatusUseCaseInput {
  int userId;
  int tripId;
  String tripStatus;

  ChangeTripStatusUseCaseInput(this.userId, this.tripId, this.tripStatus);
}

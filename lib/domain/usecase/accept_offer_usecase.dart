import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/general_response.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class AcceptOfferUseCase
    implements BaseUseCase<AcceptOfferInput, GeneralResponse> {
  final Repository _repository;

  AcceptOfferUseCase(this._repository);

  @override
  Future<Either<Failure, GeneralResponse>> execute(AcceptOfferInput input) async {
    return await _repository.acceptOffer(input.userId, input.tripId);
  }
}

class AcceptOfferInput {
  int userId;
  int tripId;

  AcceptOfferInput(this.userId, this.tripId);
}

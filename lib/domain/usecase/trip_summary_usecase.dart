import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../model/trip_details_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class TripSummaryUseCase implements BaseUseCase<TripSummaryInput, TripDetailsModel> {
  final Repository _repository;

  TripSummaryUseCase(this._repository);

  @override
  Future<Either<Failure, TripDetailsModel>> execute(TripSummaryInput input) async {
    return await _repository.tripSummary(input.userId, input.tripId);
  }
}

class TripSummaryInput {
  int userId;
  int tripId;

  TripSummaryInput(this.userId, this.tripId);
}

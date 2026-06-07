import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/general_response.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class AddOfferUseCase implements BaseUseCase<AddOfferInput, GeneralResponse> {
  final Repository _repository;

  AddOfferUseCase(this._repository);

  @override
  Future<Either<Failure, GeneralResponse>> execute(AddOfferInput input) async {
    return await _repository.addOffer(
        input.userId, input.tripId, input.driverOffer);
  }
}

class AddOfferInput {
  int userId;
  int tripId;
  double driverOffer;

  AddOfferInput(this.userId, this.tripId, this.driverOffer);
}

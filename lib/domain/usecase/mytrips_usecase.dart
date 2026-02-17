import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../model/trip_details_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class MyTripsUseCase implements BaseUseCase<MyTripsInput, List<TripDetailsModel>> {
  final Repository _repository;

  MyTripsUseCase(this._repository);

  @override
  Future<Either<Failure, List<TripDetailsModel>>> execute(MyTripsInput input) async {
    return await _repository.getMyTrips(input.endPoint,input.tripModuleId, input.userId);
  }
}

class MyTripsInput {
  String endPoint;
  String tripModuleId;
  int userId;

  MyTripsInput(this.endPoint,this.tripModuleId, this.userId);
}

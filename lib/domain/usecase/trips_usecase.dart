import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../model/trip_details_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class TripsUseCase implements BaseUseCase<TripsInput, List<TripDetailsModel>> {
  final Repository _repository;

  TripsUseCase(this._repository);

  @override
  Future<Either<Failure, List<TripDetailsModel>>> execute(
      TripsInput input) async {
    return await _repository.getTrips(
        input.endPoint,
        input.tripModuleId,
        input.userId,
        input.dateFilter,
        input.locationFilter,
        input.currentLocation,
        input.sortCriterion,
        input.serviceTypesSelectedByBusinessOwner,
        input.serviceTypesSelectedByDriver);
  }
}

class TripsInput {
  String endPoint;
  String tripModuleId;
  int userId;
  Map<String, dynamic>? dateFilter;
  Map<String, dynamic>? locationFilter;
  Map<String, dynamic>? currentLocation;
  String? sortCriterion;
  String? serviceTypesSelectedByBusinessOwner;
  String? serviceTypesSelectedByDriver;

  TripsInput(
      this.endPoint,
      this.tripModuleId,
      this.userId,
      this.dateFilter,
      this.locationFilter,
      this.currentLocation,
      this.sortCriterion,
      this.serviceTypesSelectedByBusinessOwner,
      this.serviceTypesSelectedByDriver);
}

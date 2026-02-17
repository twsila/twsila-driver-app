part of 'my_trips_bloc.dart';

@immutable
abstract class MyTripsEvent {}
class GetTripsTripModuleId extends MyTripsEvent {
  final String tripTypeId;

  GetTripsTripModuleId(this.tripTypeId);
}

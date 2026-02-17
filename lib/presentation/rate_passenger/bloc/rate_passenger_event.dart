part of 'rate_passenger_bloc.dart';

@immutable
abstract class RatePassengerEvent {}

class RatePassenger extends RatePassengerEvent {
  final int driverId;
  final int tripId;
  final double rateNumber;

  RatePassenger(this.driverId, this.tripId, this.rateNumber);
}

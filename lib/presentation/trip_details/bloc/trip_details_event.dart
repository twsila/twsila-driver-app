part of 'trip_details_bloc.dart';

@immutable
abstract class TripDetailsEvent {}

class AcceptOffer extends TripDetailsEvent {
  final int userId;
  final int tripId;
  final String captainType;
  int? driverId;

  AcceptOffer(this.userId, this.tripId, this.captainType, {this.driverId});
}

class AddOffer extends TripDetailsEvent {
  final int userId;
  final int tripId;
  final double driverOffer;
  final String captainType;
  int? driverId;

  AddOffer(this.userId, this.tripId, this.driverOffer, this.captainType,
      {this.driverId});
}

class GetTripSummary extends TripDetailsEvent {
  final int userId;
  final int tripId;

  GetTripSummary(this.userId, this.tripId);
}

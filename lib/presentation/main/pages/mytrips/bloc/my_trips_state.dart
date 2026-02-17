part of 'my_trips_bloc.dart';

@immutable
abstract class MyTripsState {}

class MyTripsInitial extends MyTripsState {}

class MyTripsLoading extends MyTripsState {}

class MyTripsSuccess extends MyTripsState {
  final List<TripDetailsModel> trips;

  MyTripsSuccess(this.trips);
}

class MyTripsFailure extends MyTripsState {
  final String message;
  final String code;

  MyTripsFailure(this.message, this.code);
}

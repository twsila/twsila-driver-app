part of 'rate_passenger_bloc.dart';

@immutable
abstract class RatePassengerState {}

class RatePassengerInitial extends RatePassengerState {}

class RatePassengerLoading extends RatePassengerState {}

class RatePassengerSuccess extends RatePassengerState {}

class RatePassengerFail extends RatePassengerState {
  final String errorMessage;

  RatePassengerFail({required this.errorMessage});
}

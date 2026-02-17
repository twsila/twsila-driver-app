part of 'trip_execution_bloc.dart';

@immutable
abstract class TripExecutionEvent {}

class changeTripStatus extends TripExecutionEvent {
  final TripDetailsModel tripDetailsModel;
  final String tripStatus;
  final bool sendRequest;
  bool? isLastStep;
  bool? openMapWidget;

  changeTripStatus(this.tripDetailsModel, this.tripStatus, this.sendRequest,
      {this.isLastStep = false, this.openMapWidget = false});
}

class getTripSummary extends TripExecutionEvent {
  final int tripId;

  getTripSummary(this.tripId);
}

class getTripStatusForStepper extends TripExecutionEvent {
  final TripDetailsModel tripDetailsModel;

  getTripStatusForStepper({required this.tripDetailsModel});
}

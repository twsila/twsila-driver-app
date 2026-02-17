part of 'trip_execution_bloc.dart';

@immutable
abstract class TripExecutionState {}

class TripExecutionInitial extends TripExecutionState {}

class TripExecutionLoading extends TripExecutionState {}

class TripExecutionSuccess extends TripExecutionState {}

class TripStatusChangedSuccess extends TripExecutionState {
  final bool isLastStep;
  final bool openMapWidget;

  TripStatusChangedSuccess(this.isLastStep,this.openMapWidget);
}

class TripCurrentStepSuccess extends TripExecutionState {
  final TripStatusStepModel tripStatusStepModel;

  TripCurrentStepSuccess(this.tripStatusStepModel);
}

class TripCurrentStepFail extends TripExecutionState {
  TripCurrentStepFail();
}

class TripSummarySuccess extends TripExecutionState {
  final TripDetailsModel tripDetailsModel;

  TripSummarySuccess(this.tripDetailsModel);
}

class TripExecutionFail extends TripExecutionState {
  final String message;

  TripExecutionFail(this.message);
}

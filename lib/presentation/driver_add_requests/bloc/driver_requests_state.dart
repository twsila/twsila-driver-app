part of 'driver_requests_bloc.dart';

@immutable
abstract class DriverRequestsState {}

class DriverRequestsInitial extends DriverRequestsState {}

class DriverRequestsLoading extends DriverRequestsState {}

class DriverRequestsSuccess extends DriverRequestsState {
  final List<AddRequestModel> requests;
  DriverRequestsSuccess(this.requests);
}

class RequestStatusChanged extends DriverRequestsState {
  DriverAcquisitionEnum driverAcquisitionEnum;
  RequestStatusChanged(this.driverAcquisitionEnum);
}

class DriverRequestsFailure extends DriverRequestsState {
  final String message;
  final String code;

  DriverRequestsFailure(this.message, this.code);
}

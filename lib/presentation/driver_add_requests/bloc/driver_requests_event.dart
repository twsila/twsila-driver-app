part of 'driver_requests_bloc.dart';

@immutable
abstract class DriverRequestsEvent {}

class getAddRequests extends DriverRequestsEvent {
  getAddRequests();
}

class changeRequestStatus extends DriverRequestsEvent {
  final int acquisitionId;
  final DriverAcquisitionEnum driverAcquisitionDecision;

  changeRequestStatus(this.acquisitionId, this.driverAcquisitionDecision);
}

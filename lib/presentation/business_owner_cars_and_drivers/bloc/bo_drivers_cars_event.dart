part of 'bo_drivers_cars_bloc.dart';

@immutable
abstract class BoDriversCarsEvent {}

class GetDriversAndCars extends BoDriversCarsEvent {
  final bool forceRefresh;

  GetDriversAndCars(this.forceRefresh);
}

class GetActiveDriversAndCars extends BoDriversCarsEvent {
  final bool forceRefresh;

  GetActiveDriversAndCars(this.forceRefresh);
}

class GetPendingDriversAndCars extends BoDriversCarsEvent {
  final bool forceRefresh;

  GetPendingDriversAndCars(this.forceRefresh);
}

class SearchDriversByMobile extends BoDriversCarsEvent {
  int mobileNumber;

  SearchDriversByMobile(this.mobileNumber);
}

class addDriverForBusinessOwner extends BoDriversCarsEvent {
  final int businessOwnerId;
  final List<int> driverIds;

  addDriverForBusinessOwner(this.businessOwnerId, this.driverIds);
}

class assignDriverForTrip extends BoDriversCarsEvent {
  final int businessOwnerId;
  final int driverId;
  final int tripId;

  assignDriverForTrip(this.businessOwnerId, this.driverId, this.tripId);
}

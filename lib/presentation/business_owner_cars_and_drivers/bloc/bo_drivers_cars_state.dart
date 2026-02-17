part of 'bo_drivers_cars_bloc.dart';

@immutable
abstract class BoDriversCarsState {}

class BoDriversCarsInitial extends BoDriversCarsState {}

class BoDriversCarsLoading extends BoDriversCarsState {}

class BoDriversCarsSuccess extends BoDriversCarsState {
  final forceRefresh;
  final List<Driver> driversList;

  BoDriversCarsSuccess(this.driversList, this.forceRefresh);
}

class BoActiveDriversAndCars extends BoDriversCarsState {
  final forceRefresh;
  final List<Driver> driversList;

  BoActiveDriversAndCars(this.driversList, this.forceRefresh);
}

class BoPendingDriversAndCars extends BoDriversCarsState {
  final forceRefresh;
  final List<Driver> driversList;

  BoPendingDriversAndCars(this.driversList, this.forceRefresh);
}

class SearchDriversSuccess extends BoDriversCarsState {
  final List<Driver> drivers;

  SearchDriversSuccess(this.drivers);
}

class getAllDriversSuccess extends BoDriversCarsState {
  final List<Driver> drivers;

  getAllDriversSuccess(this.drivers);
}

class AddDriversSuccess extends BoDriversCarsState {
  AddDriversSuccess();
}

class AssignDriversSuccess extends BoDriversCarsState {
  AssignDriversSuccess();
}

class BoDriversCarsFail extends BoDriversCarsState {
  final String message;
  final String code;

  BoDriversCarsFail(this.message, this.code);
}

class AssignDriverFail extends BoDriversCarsState {
  final String message;
  final String code;

  AssignDriverFail(this.message, this.code);
}

class SearchDriversFail extends BoDriversCarsState {
  final String message;
  final String code;

  SearchDriversFail(this.message, this.code);
}

class AddDriverFail extends BoDriversCarsState {
  final String message;
  final String code;

  AddDriverFail(this.message, this.code);
}

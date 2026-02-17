part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LoginLoadingState extends LocationState {}

class CurrentLocationSuccessState extends LocationState {
  final LocationModel currentLocation;

  CurrentLocationSuccessState(this.currentLocation);
}

class CurrentLocationFailState extends LocationState {
  final String message;
  final LocationPermission locationPermission;

  CurrentLocationFailState(this.message,this.locationPermission);
}

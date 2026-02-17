part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class getCurrentLocation extends LocationEvent {
  getCurrentLocation();
}

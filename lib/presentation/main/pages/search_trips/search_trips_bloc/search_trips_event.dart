part of 'search_trips_bloc.dart';

@immutable
abstract class SearchTripsEvent {}

class GetTripsTripModuleId extends SearchTripsEvent {
  final String tripTypeId;
  final DateFilter? dateFilter;
  final LocationFilter? locationFilter;
  final CurrentLocationFilter? currentLocation;
  final String? sortCriterion;
  final String? serviceTypesSelectedByBusinessOwner;
  final String? serviceTypesSelectedByDriver;

  GetTripsTripModuleId(
      {required this.tripTypeId,
      this.dateFilter,
      this.locationFilter,
      this.currentLocation,
      this.sortCriterion,
      this.serviceTypesSelectedByBusinessOwner,
      this.serviceTypesSelectedByDriver});
}

class getLookups extends SearchTripsEvent {
  getLookups();
}

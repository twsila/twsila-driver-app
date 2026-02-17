part of 'search_trips_bloc.dart';

@immutable
abstract class SearchTripsState {}

class SearchTripsInitial extends SearchTripsState {}

class SearchTripsLoading extends SearchTripsState {}

class SearchTripsSuccess extends SearchTripsState {
  final List<TripDetailsModel> trips;

  SearchTripsSuccess(this.trips);
}

class GetLookupsSuccessState extends SearchTripsState {
  final List<String> englishTripTitles;
  final List<String> arabicTripTitles;

  GetLookupsSuccessState(
      {required this.englishTripTitles, required this.arabicTripTitles});
}

class SearchTripsFailure extends SearchTripsState {
  final String message;
  final String code;

  SearchTripsFailure(this.message, this.code);
}

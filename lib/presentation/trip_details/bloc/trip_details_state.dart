part of 'trip_details_bloc.dart';

@immutable
abstract class TripDetailsState {}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsSuccess extends TripDetailsState {}

class OfferAcceptedSuccess extends TripDetailsState {
  final String message;

  OfferAcceptedSuccess(this.message);
}

class NewOfferSentSuccess extends TripDetailsState {
  NewOfferSentSuccess();
}

class TripSummarySuccess extends TripDetailsState {
  final TripModel tripModel;

  TripSummarySuccess(this.tripModel);
}

class TripDetailsFail extends TripDetailsState {
  final String message;

  TripDetailsFail(this.message);
}

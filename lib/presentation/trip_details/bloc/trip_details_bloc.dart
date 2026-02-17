import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/domain/usecase/add_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_accept_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_suggest_new_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trip_summary_usecase.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/usecase/accept_offer_usecase.dart';
import '../../../utils/resources/constants_manager.dart';

part 'trip_details_event.dart';

part 'trip_details_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  TripDetailsBloc() : super(TripDetailsInitial()) {
    on<AcceptOffer>(_acceptOffer);
    on<AddOffer>(_addOffer);
  }

  String _getUserFriendlyErrorMessage(String errorMessage) {
    // Handle Firebase Cloud Messaging errors
    if (errorMessage.toLowerCase().contains('token') &&
        errorMessage.toLowerCase().contains('topic') &&
        errorMessage.toLowerCase().contains('condition')) {
      return 'Unable to send notification. Please try again or contact support if the issue persists.';
    }
    return errorMessage;
  }

  FutureOr<void> _acceptOffer(
      AcceptOffer event, Emitter<TripDetailsState> emit) async {
    emit(TripDetailsLoading());
    AcceptOfferUseCase acceptOfferUseCase = instance<AcceptOfferUseCase>();
    if (event.captainType == RegistrationConstants.captain) {
      (await acceptOfferUseCase
              .execute(AcceptOfferInput(event.userId, event.tripId)))
          .fold((failure) => {
                emit(TripDetailsFail(_getUserFriendlyErrorMessage(failure.message)))
              },
              (generateOtp) {
        emit(OfferAcceptedSuccess(AppStrings.offerAccepted.tr()));
      });
    } else {
      BOAcceptOfferUseCase boAcceptOfferUseCase =
          instance<BOAcceptOfferUseCase>();
      (await boAcceptOfferUseCase.execute(BOAcceptOfferUseCaseInput(
              event.userId, event.tripId, event.driverId!)))
          .fold((failure) => {
                emit(TripDetailsFail(_getUserFriendlyErrorMessage(failure.message)))
              },
              (generateOtp) {
        emit(OfferAcceptedSuccess(AppStrings.offerAccepted.tr()));
      });
    }
  }

  FutureOr<void> _addOffer(
      AddOffer event, Emitter<TripDetailsState> emit) async {
    emit(TripDetailsLoading());
    AddOfferUseCase addOfferUseCase = instance<AddOfferUseCase>();
    if (event.captainType == RegistrationConstants.captain) {
      (await addOfferUseCase.execute(
              AddOfferInput(event.userId, event.tripId, event.driverOffer)))
          .fold((failure) => {emit(TripDetailsFail(failure.message))},
              (generateOtp) {
        emit(NewOfferSentSuccess());
      });
    } else {
      BoSuggestNewOfferUseCase boSuggestNewOfferUseCase =
          instance<BoSuggestNewOfferUseCase>();
      (await boSuggestNewOfferUseCase.execute(BoSuggestNewOfferUseCaseInput(
              event.userId, event.tripId, event.driverOffer, event.driverId!)))
          .fold((failure) => {emit(TripDetailsFail(failure.message))},
              (generateOtp) {
        emit(NewOfferSentSuccess());
      });
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/di.dart';
import '../../../domain/usecase/rate_passenger_usecase.dart';

part 'rate_passenger_event.dart';

part 'rate_passenger_state.dart';

class RatePassengerBloc extends Bloc<RatePassengerEvent, RatePassengerState> {
  RatePassengerBloc() : super(RatePassengerInitial()) {
    on<RatePassenger>(_ratePassenger);
  }

  FutureOr<void> _ratePassenger(
      RatePassenger event, Emitter<RatePassengerState> emit) async {
    emit(RatePassengerLoading());
    RatePassengerUseCase ratePassengerUseCase =
        instance<RatePassengerUseCase>();
    (await ratePassengerUseCase.execute(RatePassengerUseCaseInput(
            event.driverId, event.tripId, event.rateNumber)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(RatePassengerFail(errorMessage: failure.message))
                }, (response) async {
      // right -> data (success)
      // content
      // emit success state
      emit(RatePassengerSuccess());
    });
  }
}

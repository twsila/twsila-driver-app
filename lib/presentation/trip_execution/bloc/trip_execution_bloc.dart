import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/model/trip_details_model.dart';
import 'package:taxi_for_you/domain/usecase/change_trip_status_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_status_step_model.dart';
import '../../../domain/usecase/trip_summary_usecase.dart';
import '../../../utils/ext/enums.dart';

part 'trip_execution_event.dart';

part 'trip_execution_state.dart';

class TripExecutionBloc extends Bloc<TripExecutionEvent, TripExecutionState> {
  AppPreferences _appPreferences = instance<AppPreferences>();

  List<TripStatusStepModel> tripStatusSteps = [
    TripStatusStepModel(0, TripStatus.READY_FOR_TAKEOFF.name),
    TripStatusStepModel(1, TripStatus.HEADING_TO_PICKUP_POINT.name),
    TripStatusStepModel(2, TripStatus.ARRIVED_TO_PICKUP_POINT.name),
    TripStatusStepModel(3, TripStatus.HEADING_TO_DESTINATION.name),
    TripStatusStepModel(4, TripStatus.TRIP_COMPLETED.name),
  ];

  TripExecutionBloc() : super(TripExecutionInitial()) {
    on<getTripStatusForStepper>(_getTripStatusForStepper);
    on<changeTripStatus>(_changeTripStatus);
    on<getTripSummary>(_getTripSummary);
  }

  FutureOr<void> _changeTripStatus(
      changeTripStatus event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    ChangeTripStatusUseCase changeTripStatusUseCase =
        instance<ChangeTripStatusUseCase>();

    if (event.sendRequest) {
      (await changeTripStatusUseCase.execute(ChangeTripStatusUseCaseInput(
              _appPreferences.getCachedDriver()?.id ?? 0,
              event.tripDetailsModel.tripDetails.tripId!,
              event.tripStatus)))
          .fold(
              (failure) => {
                    // left -> failure
                    //emit failure state

                    emit(TripExecutionFail(failure.message))
                  }, (tripStatusResponse) async {
        // right -> data (success)
        // content
        // emit success state
        emit(TripStatusChangedSuccess(event.isLastStep!, event.openMapWidget!));
        // isUserLoggedInSuccessfullyStreamController.add(true);
      });
    } else {
      emit(TripStatusChangedSuccess(event.isLastStep!, event.openMapWidget!));
    }
  }

  FutureOr<void> _getTripSummary(
      getTripSummary event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    TripSummaryUseCase tripSummaryUseCase = instance<TripSummaryUseCase>();
    (await tripSummaryUseCase.execute(TripSummaryInput(
            _appPreferences.getCachedDriver()?.id ?? -1, event.tripId)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(TripExecutionFail(failure.message))
                }, (tripModel) async {
      // right -> data (success)
      // content
      // emit success state
      emit(TripSummarySuccess(tripModel));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _getTripStatusForStepper(
      getTripStatusForStepper event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());

    TripStatusStepModel? tripStatusStepModel;
    tripStatusSteps.forEach((element) {
      if (element.tripStatus == event.tripDetailsModel.tripDetails.tripStatus) {
        tripStatusStepModel =
            TripStatusStepModel(element.stepIndex, element.tripStatus);
      }
    });
    // tripStatusSteps.forEach((element) async {
    //   if (element.tripStatus == event.tripDetailsModel.tripDetails.tripStatus) {
    //     var currentStepIndex = tripStatusSteps.indexWhere((status) {
    //       return status.tripStatus == element.tripStatus;
    //     });
    //     if (element.stepIndex >= tripStatusSteps.length) {
    //       tripStatusStepModel = tripStatusSteps.last;
    //     } else {
    //       if (currentStepIndex == tripStatusSteps.first.stepIndex) {
    //         tripStatusStepModel =
    //             TripStatusStepModel(element.stepIndex, element.tripStatus);
    //       } else {
    //         tripStatusStepModel = tripStatusSteps[currentStepIndex + 1];
    //       }
    //     }
    //   }
    // });

    if (tripStatusStepModel != null) {
      emit(TripCurrentStepSuccess(tripStatusStepModel!));
    } else {
      emit(TripCurrentStepSuccess(tripStatusSteps.first));
    }
  }
}

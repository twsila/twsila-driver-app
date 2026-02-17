import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/requested_drivers_response.dart';
import 'package:taxi_for_you/domain/usecase/add_driver_bo_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_get_pending_drivers_usecase.dart';
import 'package:taxi_for_you/domain/usecase/get_business_owner_drivers_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../domain/usecase/bo_assign_driver_to_trip_usecase.dart';
import '../../../domain/usecase/search_driver_mobile_usecase.dart';

part 'bo_drivers_cars_event.dart';

part 'bo_drivers_cars_state.dart';

class BoDriversCarsBloc extends Bloc<BoDriversCarsEvent, BoDriversCarsState> {
  AppPreferences appPreferences = instance<AppPreferences>();

  BoDriversCarsBloc() : super(BoDriversCarsInitial()) {
    on<GetDriversAndCars>(_getDriversAndCars);
    on<GetActiveDriversAndCars>(_getActiveDriversAndCars);
    on<GetPendingDriversAndCars>(_getPendingDriversAndCars);
    on<SearchDriversByMobile>(_searchDriversByMobile);
    on<addDriverForBusinessOwner>(_addDriverForBusinessOwner);
    on<assignDriverForTrip>(_assignDriverForTrip);
  }

  FutureOr<void> _getDriversAndCars(
      GetDriversAndCars event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    BusinessOwnerDriversUseCase businessOwnerDriversUseCase =
        instance<BusinessOwnerDriversUseCase>();
    BOGetPendingDriversUseCase boGetPendingDriversUseCase =
        instance<BOGetPendingDriversUseCase>();
    (await businessOwnerDriversUseCase.execute(
      BusinessOwnerDriversUseCaseInput(
          appPreferences.getCachedDriver()?.id ?? 0),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(BoDriversCarsFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state

      emit(BoDriversCarsSuccess(driversList, event.forceRefresh));
    });
    (await boGetPendingDriversUseCase.execute(
      BOGetPendingDriversUseCaseInput(
          appPreferences.getCachedDriver()?.id ?? 0),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state
                  emit(BoDriversCarsFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      driversList.forEach((element) {
        element.isPending = true;
      });
      emit(BoDriversCarsSuccess(driversList, event.forceRefresh));
    });
  }

  FutureOr<void> _getActiveDriversAndCars(
      GetActiveDriversAndCars event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    BusinessOwnerDriversUseCase businessOwnerDriversUseCase =
        instance<BusinessOwnerDriversUseCase>();
    (await businessOwnerDriversUseCase.execute(
      BusinessOwnerDriversUseCaseInput(
          appPreferences.getCachedDriver()?.id ?? 0),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(BoDriversCarsFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state

      emit(BoActiveDriversAndCars(driversList, event.forceRefresh));
    });
  }  FutureOr<void> _getPendingDriversAndCars(
      GetPendingDriversAndCars event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    BOGetPendingDriversUseCase boGetPendingDriversUseCase =
        instance<BOGetPendingDriversUseCase>();
    (await boGetPendingDriversUseCase.execute(
      BOGetPendingDriversUseCaseInput(
          appPreferences.getCachedDriver()?.id ?? 0),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(BoDriversCarsFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      driversList.forEach((element) {
        element.isPending = true;
      });
      emit(BoPendingDriversAndCars(driversList, event.forceRefresh));
    });
  }

  FutureOr<void> _searchDriversByMobile(
      SearchDriversByMobile event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    SearchDriversByMobileUseCase searchDriversByMobileUseCase =
        instance<SearchDriversByMobileUseCase>();
    (await searchDriversByMobileUseCase.execute(
      SearchDriversByMobileUseCaseInput(event.mobileNumber),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(SearchDriversFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      emit(SearchDriversSuccess(driversList));
    });
  }

  FutureOr<void> _addDriverForBusinessOwner(
      addDriverForBusinessOwner event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    AddDriverForBOUseCase addDriverForBOUseCase =
        instance<AddDriverForBOUseCase>();
    (await addDriverForBOUseCase.execute(
      AddDriverForBOUseCaseInput(event.businessOwnerId, event.driverIds),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(AddDriverFail(failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      emit(AddDriversSuccess());
    });
  }

  FutureOr<void> _assignDriverForTrip(
      assignDriverForTrip event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    BoAssignDriverToTripUseCase assignDriverToTripUseCase =
        instance<BoAssignDriverToTripUseCase>();
    (await assignDriverToTripUseCase.execute(
      BoAssignDriverToTripUseCaseInput(
          event.businessOwnerId, event.driverId, event.tripId),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(AssignDriverFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      emit(AssignDriversSuccess());
    });
  }
}

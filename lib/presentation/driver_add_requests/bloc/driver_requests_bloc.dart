import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/add_requests_usecase.dart';
import 'package:taxi_for_you/domain/usecase/change_request_status.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/add_request_model.dart';
import '../../../utils/ext/enums.dart';

part 'driver_requests_event.dart';

part 'driver_requests_state.dart';

class DriverRequestsBloc
    extends Bloc<DriverRequestsEvent, DriverRequestsState> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  DriverRequestsBloc() : super(DriverRequestsInitial()) {
    on<getAddRequests>(_getAddRequests);
    on<changeRequestStatus>(_changeRequestStatus);
  }

  FutureOr<void> _getAddRequests(
      getAddRequests event, Emitter<DriverRequestsState> emit) async {
    emit(DriverRequestsLoading());
    AddRequestsUseCase addRequestsUseCase = instance<AddRequestsUseCase>();
    (await addRequestsUseCase.execute(AddRequestsUseCaseInput(
      _appPreferences.getCachedDriver()!.id!,
    )))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(DriverRequestsFailure(
                      failure.message, failure.code.toString()))
                }, (requests) async {
      // right -> data (success)
      // content
      // emit success state

      emit(DriverRequestsSuccess(requests));
    });
  }

  FutureOr<void> _changeRequestStatus(
      changeRequestStatus event, Emitter<DriverRequestsState> emit) async {
    emit(DriverRequestsLoading());
    ChangeRequestStatusUseCase changeRequestStatusUseCase =
        instance<ChangeRequestStatusUseCase>();
    (await changeRequestStatusUseCase.execute(ChangeRequestStatusUseCaseInput(
            event.acquisitionId, event.driverAcquisitionDecision.name)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(DriverRequestsFailure(
                      failure.message, failure.code.toString()))
                }, (response) async {
      // right -> data (success)
      // content
      // emit success state

      emit(RequestStatusChanged(event.driverAcquisitionDecision));
    });
  }
}

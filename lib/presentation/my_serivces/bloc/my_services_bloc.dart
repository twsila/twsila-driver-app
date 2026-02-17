import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/usecase/service_status_usecase.dart';

part 'my_services_event.dart';

part 'my_services_state.dart';

class MyServicesBloc extends Bloc<MyServicesEvent, MyServicesState> {
  AppPreferences _appPreferences = instance<AppPreferences>();

  MyServicesBloc() : super(MyServicesInitial()) {
    on<GetServiceStatus>(_getServiceStatus);
  }

  FutureOr<void> _getServiceStatus(
      GetServiceStatus event, Emitter<MyServicesState> emit) async {
    String userId = _appPreferences.getCachedDriver()?.id.toString() ?? "";
    ServiceStatusUseCase serviceStatusUseCase =
        instance<ServiceStatusUseCase>();
    emit(ServiceStatusLoading());
    (await serviceStatusUseCase.execute(ServiceStatusInput(userId))).fold(
        (failure) => {
              emit(ServiceStatusFail(failure.message, failure.code.toString()))
            }, (result) {
      emit(ServiceStatusSuccess(result.result));
    });
  }
}

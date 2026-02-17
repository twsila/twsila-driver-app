import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/lookup_by_key_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/lookupValueModel.dart';

part 'filter_event.dart';

part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  FilterBloc() : super(FilterInitial()) {
    on<getServiceLookup>(_getServiceLookup);
  }

  FutureOr<void> _getServiceLookup(
      getServiceLookup event, Emitter<FilterState> emit) async {
    emit(FilterLoading());
    LookupByKeyUseCase lookupByKeyUseCase = instance<LookupByKeyUseCase>();
    String lang = _appPreferences.getAppLanguage();
    (await lookupByKeyUseCase.execute(LookupByKeyUseCaseInput(
      event.key,
      lang,
    )))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(FilterFailure(failure.message, failure.code.toString()))
                }, (services) async {
      // right -> data (success)
      // content
      // emit success state

      emit(ServiceLookupSuccess(services));
    });
  }
}

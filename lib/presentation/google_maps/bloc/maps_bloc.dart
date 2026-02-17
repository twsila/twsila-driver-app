import 'package:bloc/bloc.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../model/location_model.dart';
import '../model/maps_repo.dart';
import 'maps_events.dart';
import 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvents, MapsState> {
  MapsRepo mapsRepo = MapsRepo();
  AppPreferences appPreferences = instance<AppPreferences>();

  MapsBloc(this.mapsRepo) : super(CurrentLocationIsNotLoading()) {
    on<GetCurrentLocation>(_getCurrentLocation);
    on<GetUserConfigAndPagesForUser>(_getUserConfigAndPagesForUser);
  }

  void _getCurrentLocation(
      GetCurrentLocation event, Emitter<MapsState> emit) async {
    emit(CurrentLocationIsLoading());

    try {
      LocationModel location = await mapsRepo.getUserCurrentLocation();
      emit(CurrentLocationLoadedSuccessfully(currentLocation: location));
    } catch (e) {
      emit(CurrentLocationFailed(errorMessage: e.toString()));
    }
  }

  void _getUserConfigAndPagesForUser(
      GetUserConfigAndPagesForUser event, Emitter<MapsState> emit) async {
    emit(CurrentLocationIsLoading());
    DriverBaseModel driverBaseModel = await appPreferences.getCachedDriver()!;

    // if (driverBaseModel.disabled != null && driverBaseModel.disabled == false) {
      //user allowed to myprofile page only
    //   emit(CurrentUserConfigAndPagesSuccess(2, [2]));
    // } else {
      //user allowed to use all pages
      emit(CurrentUserConfigAndPagesSuccess(0, [0, 1, 2]));
    // }
  }
}

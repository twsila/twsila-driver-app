import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/date_filter_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/domain/model/sorting_model.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../domain/usecase/lookups_usecase.dart';
import '../../../../../utils/ext/enums.dart';
import '../../../../../utils/resources/constants_manager.dart';
import '../../../../../utils/resources/strings_manager.dart';

part 'search_trips_event.dart';

part 'search_trips_state.dart';

class SearchTripsBloc extends Bloc<SearchTripsEvent, SearchTripsState> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  SearchTripsBloc() : super(SearchTripsInitial()) {
    on<GetTripsTripModuleId>(_getTripsByModuleId);
    on<getLookups>(_getLookups);
  }

  List<SortingModel> getSortingList(DriverBaseModel driver) {
    List<SortingModel> sortingModelList = [
      SortingModel(TripModelType.ALL_TRIPS, SortCriterion.REQUEST_DATE,
          AppStrings.requestedDate.tr()),
      SortingModel(TripModelType.ALL_TRIPS, SortCriterion.NEAREST_TO_ME,
          AppStrings.nearestToMe.tr()),
      SortingModel(TripModelType.ALL_TRIPS, SortCriterion.SHORT_DISTANCE,
          AppStrings.shortestWay.tr()),
      SortingModel(TripModelType.ALL_TRIPS, SortCriterion.HIGH_PRICE,
          AppStrings.highestPrice.tr()),
      SortingModel(TripModelType.ALL_TRIPS, SortCriterion.TOP_RATED_CLIENT,
          AppStrings.highestRateClient.tr()),
      // SortingModel(
      //     TripModelType.OFFERED_TRIPS, null, AppStrings.offerHasBeenSent.tr(),
      //     sendCurrentLocation: false),
    ];
    if (driver.captainType == RegistrationConstants.captain) {
      if ((driver as Driver).serviceTypes!.contains(TripType.GOODS)) {
        sortingModelList.add(
          SortingModel(TripModelType.ALL_TRIPS, SortCriterion.LIGHT_WEIGHT,
              AppStrings.lightWeight.tr()),
        );
      }
    }
    return sortingModelList;
  }

  FutureOr<void> _getLookups(
      getLookups event, Emitter<SearchTripsState> emit) async {
    emit(SearchTripsLoading());

    LookupsUseCase lookupsUseCase = instance<LookupsUseCase>();
    (await lookupsUseCase.execute(LookupsUseCaseInput())).fold(
        (failure) => {
              // left -> failure
              //emit failure state

              emit(SearchTripsFailure(failure.message, failure.code.toString()))
            }, (lookupsResponse) async {
      // right -> data (success)
      // content
      // emit success state
      List<String> englishTitles = lookupsResponse.result.tripModelType;
      List<String> arabicTitles = lookupsResponse.result.tripModelTypeAr;

      emit(GetLookupsSuccessState(
          englishTripTitles: englishTitles, arabicTripTitles: arabicTitles));
    });
  }

  FutureOr<void> _getTripsByModuleId(
      GetTripsTripModuleId event, Emitter<SearchTripsState> emit) async {
    emit(SearchTripsLoading());
    TripsUseCase tripsUseCase = instance<TripsUseCase>();
    String endPoint = _appPreferences.getCachedDriver()?.captainType ==
            RegistrationConstants.captain
        ? EndPoints.DriversTrips
        : EndPoints.BusinessOwnerTrips;
    (await tripsUseCase.execute(TripsInput(
            endPoint,
            event.tripTypeId,
            _appPreferences.getCachedDriver()?.id ?? -1,
            event.dateFilter?.toJson() ?? null,
            event.locationFilter != null
                ? event.locationFilter!.toJson()
                : null,
            event.currentLocation?.toJson() ?? null,
            event.sortCriterion,
            event.serviceTypesSelectedByBusinessOwner,
            event.serviceTypesSelectedByDriver)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(SearchTripsFailure(
                      failure.message, failure.code.toString()))
                }, (trips) async {
      // right -> data (success)
      // content
      // emit success state

      emit(SearchTripsSuccess(trips));
    });
  }
}

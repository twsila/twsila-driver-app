import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/domain/model/sorting_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/search_trips_bloc/search_trips_bloc.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_details_view.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/trip_execution_view.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/date_filter_model.dart';
import '../../../../../domain/model/driver_model.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import '../../../../../utils/resources/values_manager.dart';
import '../../../../common/widgets/custom_scaffold.dart';
import '../../../../common/widgets/page_builder.dart';
import '../../../../filter_trips/view/helpers/filtration_helper.dart';
import '../../../../google_maps/model/location_model.dart';
import '../../../../google_maps/model/maps_repo.dart';
import '../../../../location_bloc/location_bloc.dart';

List<String> tripsTitles = [];
List<String> englishTripTitles = [];

class SearchTripsPage extends StatefulWidget {
  SearchTripsPage() : super();

  @override
  _SearchTripsPageState createState() => _SearchTripsPageState();
}

class _SearchTripsPageState extends State<SearchTripsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  bool _loadingTripsList = false;

  MapsRepo mapsRepo = MapsRepo();
  LocationModel? currentLocation;
  String currentCityName = '';
  CurrentLocationFilter? currentLocationFilter;

  int currentSortingIndex = 1;
  List<TripDetailsModel> trips = [];
  DateFilter? dateFilter = null;
  int currentIndex = 0;
  List<SortingModel> sortingModelList = [];
  DriverBaseModel? driver;

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorManager.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.sortBy.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.blackTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                itemCount: sortingModelList.length,
                itemBuilder: (context, index) {
                  final selectedSortModel = sortingModelList[index];
                  final isSelected = currentSortingIndex == index;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentSortingIndex = index;
                          BlocProvider.of<SearchTripsBloc>(context).add(
                              GetTripsTripModuleId(
                                  tripTypeId: selectedSortModel
                                      .tripModelType!.name
                                      .toString(),
                                  sortCriterion:
                                      selectedSortModel.id?.name.toString(),
                                  currentLocation:
                                      selectedSortModel.sendCurrentLocation!
                                          ? currentLocationFilter
                                          : null,
                                  serviceTypesSelectedByBusinessOwner: driver!
                                              .captainType ==
                                          RegistrationConstants.businessOwner
                                      ? FiltrationHelper()
                                          .serviceTypesList
                                          .join(",")
                                      : null,
                                  serviceTypesSelectedByDriver:
                                      driver!.captainType ==
                                              RegistrationConstants.captain
                                          ? (driver as Driver)
                                              .serviceTypes!
                                              .join(',')
                                          : null));
                          Navigator.pop(context);
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedSortModel.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? ColorManager.secondaryColor
                                          : ColorManager.headersTextColor,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: ColorManager.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  @override
  void initState() {
    // BlocProvider.of<SearchTripsBloc>(context).add(getLookups());
    // Try to get location, but don't block if it fails
    BlocProvider.of<LocationBloc>(context).add(getCurrentLocation());
    driver = _appPreferences.getCachedDriver();
    sortingModelList = SearchTripsBloc().getSortingList(driver!);

    // Load trips even without location - location is optional for viewing trips
    // Location is only needed for "nearby trips" feature
    BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
        tripTypeId: TripModelType.ALL_TRIPS.name,
        currentLocation: null, // Allow null location
        serviceTypesSelectedByBusinessOwner:
            driver!.captainType == RegistrationConstants.businessOwner
                ? FiltrationHelper().serviceTypesList.join(",")
                : null,
        serviceTypesSelectedByDriver:
            driver!.captainType == RegistrationConstants.captain
                ? (driver as Driver).serviceTypes!.join(',')
                : null));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final driverName = driver != null
        ? '${driver!.firstName ?? ''} ${driver!.lastName ?? ''}'.trim()
        : '';
    final welcomeText = AppStrings.welcomeTo.tr().split(' ').first;
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: false,
        appbarTitleWidget: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 4,
            end: 4,
            bottom: 16,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  welcomeText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  driverName.isEmpty ? AppStrings.twsela.tr() : driverName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        appBarBackgroundColor: ColorManager.splashBGColor,
        appBarForegroundColor: Colors.white,
        appBarShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        extendAppBarIntoSafeArea: true,
        preferredToolbarHeight: 72,
        showLanguageChange: false,
        centerTitle: false,
        elevation: 0,
        appBarActions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () async {
              FilterTripsModel filterData =
                  await Navigator.pushNamed(context, Routes.filterTrips)
                      as FilterTripsModel;
              BlocProvider.of<SearchTripsBloc>(context).add(
                  GetTripsTripModuleId(
                      tripTypeId: filterData.isOfferedTrips!
                          ? TripModelType.OFFERED_TRIPS.name
                          : TripModelType.ALL_TRIPS.name,
                      dateFilter: filterData.dateFilter,
                      locationFilter: filterData.locationFilter,
                      currentLocation: filterData.currentLocation,
                      serviceTypesSelectedByBusinessOwner:
                          driver!.captainType ==
                                  RegistrationConstants.businessOwner
                              ? filterData.filteredService
                              : null,
                      serviceTypesSelectedByDriver:
                          driver!.captainType == RegistrationConstants.captain
                              ? filterData.filteredService
                              : null));
            },
            tooltip: AppStrings.trip.tr(),
          ),
        ],
        extendBodyBehindAppBar: false,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          _loadingTripsList = true;
        } else {
          _loadingTripsList = false;
        }

        if (state is CurrentLocationSuccessState) {
          currentLocation = state.currentLocation;
          currentLocationFilter = CurrentLocationFilter(
              latitude: currentLocation!.latitude,
              longitude: currentLocation!.longitude,
              cityName: '');
          currentLocationFilter!.cityName = currentLocation!.cityName!;
          BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
              tripTypeId: sortingModelList[currentSortingIndex]
                  .tripModelType!
                  .name
                  .toString(),
              sortCriterion: sortingModelList[1].id!.name.toString(),
              currentLocation: currentLocationFilter,
              serviceTypesSelectedByBusinessOwner:
                  driver!.captainType == RegistrationConstants.businessOwner
                      ? FiltrationHelper().serviceTypesList.join(",")
                      : null,
              serviceTypesSelectedByDriver:
                  driver!.captainType == RegistrationConstants.captain
                      ? (driver as Driver).serviceTypes!.join(',')
                      : null));
        }

        if (state is CurrentLocationFailState) {
          // Location is optional - show a non-blocking message but allow app to continue
          // Only show dialog if location is permanently denied, otherwise silently continue
          if (state.locationPermission == LocationPermission.deniedForever) {
            CustomDialog(context).showCupertinoDialog(
                AppStrings.location_required.tr(),
                "${state.message}. ${AppStrings.locationEnable.tr()}",
                AppStrings.tryAgain.tr(),
                AppStrings.cancel.tr(),
                ColorManager.accentTextColor, () {
              Geolocator.openLocationSettings();
              Navigator.pop(context);
            }, () {
              Navigator.pop(context);
            });
          }
          // If location is denied but not forever, continue without location
          // User can still use the app, just without location-based features
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            // Try to refresh location, but don't block if it fails
            BlocProvider.of<LocationBloc>(context).add(getCurrentLocation());
            // Also refresh trips list
            BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
                tripTypeId: sortingModelList[currentSortingIndex]
                    .tripModelType!
                    .name
                    .toString(),
                sortCriterion:
                    sortingModelList[currentSortingIndex].id?.name.toString() ??
                        null,
                currentLocation: currentLocationFilter,
                serviceTypesSelectedByBusinessOwner:
                    driver!.captainType == RegistrationConstants.businessOwner
                        ? FiltrationHelper().serviceTypesList.join(",")
                        : null,
                serviceTypesSelectedByDriver:
                    driver!.captainType == RegistrationConstants.captain
                        ? (driver as Driver).serviceTypes!.join(',')
                        : null));
          },
          child: BlocConsumer<SearchTripsBloc, SearchTripsState>(
            listener: (context, state) {
              if (state is SearchTripsLoading) {
                _loadingTripsList = true;
              } else {
                _loadingTripsList = false;
              }
              if (state is GetLookupsSuccessState) {
                englishTripTitles.addAll(state.englishTripTitles);
                tripsTitles.clear();
                if (_appPreferences.getAppLanguage() ==
                    LanguageType.ARABIC.getValue()) {
                  tripsTitles.addAll(state.arabicTripTitles);
                } else {
                  tripsTitles.addAll(state.englishTripTitles);
                }
                BlocProvider.of<SearchTripsBloc>(context).add(
                    GetTripsTripModuleId(
                        tripTypeId: TripModelType.ALL_TRIPS.name));
              }

              if (state is SearchTripsSuccess) {
                trips = state.trips;
              }
              if (state is SearchTripsFailure) {
                CustomDialog(context)
                    .showErrorDialog('', '', "${state.code} ${state.message}");
              }
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _loadingTripsList
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            ColorManager.primary,
                                          ),
                                          backgroundColor: ColorManager.primary
                                              .withOpacity(0.15),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppStrings.loading.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: ColorManager.hintTextColor,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              : trips.length == 0
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.inbox_rounded,
                                              size: 64,
                                              color: ColorManager.hintTextColor
                                                  .withOpacity(0.5),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              AppStrings.noTripsAvailable.tr(),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: ColorManager
                                                        .headersTextColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              AppStrings.goodsTrips.tr(),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: ColorManager
                                                        .hintTextColor,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.only(
                                        bottom: 72,
                                        top: 4,
                                      ),
                                      itemCount: trips.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: tripItemView(trips[index]),
                                        );
                                      },
                                    ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Material(
                      elevation: 4,
                      shadowColor: ColorManager.secondaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      color: ColorManager.secondaryColor,
                      child: InkWell(
                        onTap: _showBottomSheet,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.sort_rounded,
                                color: ColorManager.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.sortBy.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            },
          ),
        );
      },
    );
  }

  tripTitleItemView(int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
            BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
                tripTypeId: TripModelType.ALL_TRIPS.name, dateFilter: null));
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSize.s3),
          padding: EdgeInsets.symmetric(horizontal: AppSize.s6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: currentIndex == index
                  ? ColorManager.purpleMainTextColor
                  : ColorManager.white,
              border: Border.all(color: ColorManager.borderColor)),
          child: Center(
            child: Text(
              tripsTitles[index],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: currentIndex == index
                      ? ColorManager.white
                      : ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  tripItemView(TripDetailsModel trip) {
    String? date;
    if (trip.tripDetails.date != null) {
      // date = trip.tripDetails.date!.formatStringToDateString();
      date = trip.tripDetails.date!.getTimeStampFromDate();
    }
    return CustomCard(
      onClick: () {
        if (trip.tripDetails.acceptedOffer != null)
          Navigator.pushNamed(context, Routes.tripExecution,
                  arguments: TripExecutionArguments(trip))
              .then((value) =>
                  BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
                      tripTypeId: sortingModelList[currentSortingIndex]
                          .tripModelType!
                          .name
                          .toString(),
                      dateFilter: null,
                      sortCriterion:
                          currentLocation != null && currentLocationFilter == 1
                              ? sortingModelList[1].id!.name.toString()
                              : sortingModelList[currentSortingIndex]
                                  .id!
                                  .name
                                  .toString(),
                      currentLocation: currentLocation != null
                          ? currentLocationFilter
                          : null,
                      serviceTypesSelectedByBusinessOwner:
                          driver!.captainType == RegistrationConstants.businessOwner
                              ? FiltrationHelper().serviceTypesList.join(",")
                              : null,
                      serviceTypesSelectedByDriver:
                          driver!.captainType == RegistrationConstants.captain
                              ? (driver as Driver).serviceTypes!.join(',')
                              : null)));
        else
          Navigator.pushNamed(context, Routes.tripDetails,
                  arguments: TripDetailsArguments(tripModel: trip))
              .then((value) => BlocProvider.of<SearchTripsBloc>(context).add(
                  GetTripsTripModuleId(
                      tripTypeId: sortingModelList[currentSortingIndex]
                          .tripModelType!
                          .name
                          .toString(),
                      dateFilter: null,
                      sortCriterion:
                          currentLocation != null && currentLocationFilter == 1
                              ? sortingModelList[1].id!.name.toString()
                              : sortingModelList[currentSortingIndex]
                                  .id!
                                  .name
                                  .toString(),
                      currentLocation: currentLocation != null
                          ? currentLocationFilter
                          : null,
                      serviceTypesSelectedByBusinessOwner:
                          driver!.captainType == RegistrationConstants.businessOwner
                              ? FiltrationHelper().serviceTypesList.join(",")
                              : null,
                      serviceTypesSelectedByDriver:
                          driver!.captainType == RegistrationConstants.captain
                              ? (driver as Driver).serviceTypes!.join(',')
                              : null)));
      },
      bodyWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlueBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trip.tripDetails.date != null &&
                                trip.tripDetails.date != ""
                            ? Icons.schedule_rounded
                            : Icons.flash_on_rounded,
                        size: 16,
                        color: ColorManager.headersTextColor,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          date != null && date != ""
                              ? "${AppStrings.scheduled.tr()} : $date"
                              : AppStrings.asSoonAsPossible.tr(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorManager.headersTextColor,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w600,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  getIconName(trip.tripDetails.tripType!),
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            getTitle(trip.tripDetails.tripType!),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.blackTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize.s16,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: ColorManager.hintTextColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${trip.tripDetails.pickupLocation.locationName} – ${trip.tripDetails.destinationLocation.locationName}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontSize: FontSize.s14,
                        height: 1.35,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          tripStatusWidget(trip),
        ],
      ),
    );
  }

  Widget tripStatusWidget(TripDetailsModel trip) {
    if (trip.tripDetails.offers!.length == 0 &&
        trip.tripDetails.acceptedOffer == null) {
      return _statusChip(
        label: AppStrings.waitingCaptainsOffers.tr(),
        backgroundColor: ColorManager.supportTextColor.withOpacity(0.12),
        textColor: ColorManager.supportTextColor,
        icon: Icons.schedule_rounded,
      );
    } else if (trip.tripDetails.offers!.length > 0 &&
        trip.tripDetails.acceptedOffer == null) {
      return handleOfferStatusWidget(trip.tripDetails.offers![0],
          getCurrency(trip.tripDetails.passenger?.countryCode ?? ""));
    } else if (trip.tripDetails.acceptedOffer != null) {
      return _statusChip(
        label: AppStrings.offerAccepted.tr(),
        backgroundColor: ColorManager.primary.withOpacity(0.12),
        textColor: ColorManager.primary,
        icon: Icons.check_circle_rounded,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _statusChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.w600,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget handleOfferStatusWidget(Offer offer, String currency) {
    if (offer.acceptanceStatus == AcceptanceType.PROPOSED.name) {
      return _statusChip(
        label:
            "${AppStrings.offerHasBeenSent.tr()} (${offer.driverOfferFormatted} $currency)",
        backgroundColor: ColorManager.purpleMainTextColor.withOpacity(0.12),
        textColor: ColorManager.purpleMainTextColor,
        icon: Icons.send_rounded,
      );
    } else if (offer.acceptanceStatus == AcceptanceType.EXPIRED.name) {
      return _statusChip(
        label:
            "${AppStrings.clientRejectYourOffer.tr()} (${offer.driverOfferFormatted} $currency)",
        backgroundColor: ColorManager.error.withOpacity(0.1),
        textColor: ColorManager.error,
        icon: Icons.cancel_rounded,
      );
    } else {
      return _statusChip(
        label:
            "${AppStrings.offerAccepted.tr()} ${AppStrings.waitingClientAcceptance.tr()}",
        backgroundColor: ColorManager.primary.withOpacity(0.12),
        textColor: ColorManager.primary,
        icon: Icons.hourglass_top_rounded,
      );
    }
  }

  String handleDateString(String dateString) {
    DateTime parseDate =
        new DateFormat(Constants.dateFormatterString).parse(dateString);
    String date = DateFormat(
            Constants.dateFormatterString, _appPreferences.getAppLanguage())
        .format(parseDate);
    return date;
  }
}

class TripTitleModel {
  int id;
  String title;
  bool? isSelected;

  TripTitleModel(this.id, this.title, {this.isSelected = false});
}

class FilterTripsModel {
  DateFilter? dateFilter;
  LocationFilter? locationFilter;
  CurrentLocationFilter? currentLocation;
  bool? isOfferedTrips;
  String? filteredService;

  FilterTripsModel({
    this.dateFilter,
    this.locationFilter,
    this.currentLocation,
    this.isOfferedTrips,
    this.filteredService,
  });
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:taxi_for_you/domain/model/trip_status_step_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_stepper.dart'
    as stepper;
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/trip_execution/helper/location_helper.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../domain/model/trip_details_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../google_maps/model/location_model.dart';
import '../../google_maps/model/maps_repo.dart';
import '../../rate_passenger/view/rate_passenger_view.dart';
import '../../trip_details/view/more_details_widget/more_details_widget.dart';
import '../bloc/trip_execution_bloc.dart';

import 'navigation_tracking_view.dart';

class TripExecutionView extends StatefulWidget {
  TripDetailsModel tripModel;

  TripExecutionView({required this.tripModel});

  @override
  State<TripExecutionView> createState() => _TripExecutionViewState();
}

class _TripExecutionViewState extends State<TripExecutionView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  MapsRepo mapsRepo = MapsRepo();
  late Timer _timer;
  late double distanceBetweenCurrentAndSource;
  LocationModel? currentLocation;
  bool isUserArrivedSource = false;
  String driverServiceType = "";
  TripStatusStepModel tripStatusStepModel =
      TripStatusStepModel(0, TripStatus.READY_FOR_TAKEOFF.name);
  String currentEstimatedTime = AppStrings.gettingEstimatedTime.tr();

  // REQUIRED: USED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 0.

  // OPTIONAL: can be set directly.
  int dotCount = 5;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

  Future<void> getCurrentLocation() async {
    currentLocation = await mapsRepo.getUserCurrentLocation();
    distanceBetweenCurrentAndSource = LocationHelper()
        .distanceBetweenTwoLocationInMeters(
            lat1: currentLocation!.latitude,
            long1: currentLocation!.longitude,
            lat2: widget.tripModel.tripDetails.pickupLocation.latitude!,
            long2: widget.tripModel.tripDetails.pickupLocation.longitude!);
  }

  @override
  void initState() {
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("🎯 TRIP EXECUTION - DATA FROM BACKEND");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("📌 PICKUP FROM BACKEND:");
    print(
        "   Name: ${widget.tripModel.tripDetails.pickupLocation.locationName}");
    print("   Lat: ${widget.tripModel.tripDetails.pickupLocation.latitude}");
    print("   Long: ${widget.tripModel.tripDetails.pickupLocation.longitude}");
    print("📌 DESTINATION FROM BACKEND:");
    print(
        "   Name: ${widget.tripModel.tripDetails.destinationLocation.locationName}");
    print(
        "   Lat: ${widget.tripModel.tripDetails.destinationLocation.latitude}");
    print(
        "   Long: ${widget.tripModel.tripDetails.destinationLocation.longitude}");
    print(
        "📌 TRIP STATUS FROM BACKEND: ${widget.tripModel.tripDetails.tripStatus}");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    driverServiceType = _appPreferences.getCachedDriver()!.captainType ==
            RegistrationConstants.captain
        ? (_appPreferences.getCachedDriver()! as Driver).serviceTypes!.first
        : "";
    BlocProvider.of<TripExecutionBloc>(context)
        .add(getTripStatusForStepper(tripDetailsModel: widget.tripModel));
    _timer = Timer.periodic(
        Duration(seconds: Constants.refreshEstimatedTimeInSeconds),
        (Timer t) async {
      handleEstiamatedArrivalTime();
    });
    super.initState();
  }

  void handleEstiamatedArrivalTime() async {
    if (activeStep == 0 || activeStep == 1) {
      currentLocation = await mapsRepo.getUserCurrentLocation();
      if (currentLocation != null) {
        currentEstimatedTime = await LocationHelper()
            .getArrivalTimeFromCurrentToLocation(
                currentLocation: currentLocation!,
                destinationLocation: LocationModel(
                    locationName: widget.tripModel.tripDetails.pickupLocation
                            .locationName ??
                        "",
                    latitude:
                        widget.tripModel.tripDetails.pickupLocation.latitude!,
                    longitude: widget
                        .tripModel.tripDetails.pickupLocation.longitude!));
        setState(() {});
      }
    } else {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
        extendAppBarIntoSafeArea: true,
        appBarForegroundColor: Colors.white,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<TripExecutionBloc, TripExecutionState>(
      listener: (context, state) {
        if (state is TripExecutionLoading) {
          startLoading();
        } else {
          stopLoading();
        }

        if (state is TripStatusChangedSuccess) {
          if (state.isLastStep) {
            Navigator.pushReplacementNamed(context, Routes.ratePassenger,
                arguments: RatePassengerArguments(widget.tripModel));
          } else {
            this.tripStatusStepModel.stepIndex++;
          }
        }
        if (state is TripCurrentStepSuccess) {
          this.tripStatusStepModel = state.tripStatusStepModel;
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTrackingWidget(),
                    const SizedBox(height: 16),
                    tripDataHeader(),
                    const SizedBox(height: 16),
                    _fromToWidget(),
                    const SizedBox(height: 20),
                    TripStepperWidget(tripStatusStepModel),
                    const SizedBox(height: 20),
                    TripDetailsWidget(),
                    const SizedBox(height: 20),
                    MoreDetailsWidget(
                      transportationBaseModel: widget.tripModel.tripDetails,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 4,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: ColorManager.splashBGColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.splashBGColor.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
            color: Colors.white,
            style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              AppStrings.requestDetails.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ShowTrackingWidget() {
    return Visibility(
      visible: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorManager.borderColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.headersTextColor.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.navigateToTrackingPage.tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorManager.splashBGColor,
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            CustomTextButton(
              width: AppSize.s120,
              height: AppSize.s40,
              backgroundColor: ColorManager.splashBGColor,
              isWaitToEnable: false,
              text: AppStrings.navigation.tr(),
              icon: const Icon(Icons.map_rounded, color: Colors.white, size: 20),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.locationTrackingPage,
                  arguments: NavigationTrackingArguments(
                    widget.tripModel,
                    currentStepIndex: tripStatusStepModel.stepIndex,
                    currentTripStatus: tripStatusStepModel.tripStatus,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget TripDetailsWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tripDetails.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColorManager.formHintTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: detailsItem(
                    ImageAssets.tripDetailsProfileIc,
                    AppStrings.client.tr(),
                    "${widget.tripModel.tripDetails.passenger!.firstName} ${widget.tripModel.tripDetails.passenger!.lastName}"),
              ),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri(
                      scheme: 'tel',
                      path:
                          '${widget.tripModel.tripDetails.passenger!.mobile.toString()}'));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorManager.splashBGColor.withOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.call_rounded,
                    color: ColorManager.splashBGColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          detailsItem(
              ImageAssets.tripDetailsVisaIcon,
              AppStrings.withBudget.tr(),
              "${widget.tripModel.tripDetails.offers?.first.driverOfferFormatted ?? ""} ${getCurrency(widget.tripModel.tripDetails.passenger?.countryCode ?? "")}"),
          const SizedBox(height: 12),
          detailsItem(
              widget.tripModel.tripDetails.date != null
                  ? ImageAssets.scheduledTripIc
                  : ImageAssets.tripDetailsAsapIcon,
              AppStrings.type.tr(),
              widget.tripModel.tripDetails.date != null
                  ? AppStrings.scheduled.tr()
                  : AppStrings.asSoonAsPossible.tr()),
        ],
      ),
    );
  }

  Widget tripDataHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              getTitle(widget.tripModel.tripDetails.tripType!),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorManager.blackTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ColorManager.splashBGColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              getIconName(widget.tripModel.tripDetails.tripType!),
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget detailsItem(String iconPath, String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          iconPath,
          width: AppSize.s20,
          height: AppSize.s20,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorManager.formHintTextColor,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                data,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorManager.headersTextColor,
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fromToWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(Icons.trip_origin_rounded, size: 22, color: ColorManager.splashBGColor),
              const SizedBox(height: 8),
              Icon(Icons.location_on_rounded, size: 22, color: ColorManager.splashBGColor),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppStrings.from.tr()} ${widget.tripModel.tripDetails.pickupLocation.locationName}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  "${AppStrings.to.tr()} ${widget.tripModel.tripDetails.destinationLocation!.locationName}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget TripStepperWidget(TripStatusStepModel tripStatusStepModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(primary: ColorManager.splashBGColor),
        ),
        child: stepper.CustomStepper(
          // stepIndicatorAlignment is set to StepIndicatorAlignment.left by default if not configured
          stepIndicatorAlignment:
              _appPreferences.getAppLanguage() == LanguageType.ARABIC
                  ? stepper.StepIndicatorAlignment.right
                  : stepper.StepIndicatorAlignment.left,
          // dottedLine is set to false by default if not configured
          dottedLine: false,
          currentStep: tripStatusStepModel.stepIndex,
          onStepContinue: () {
            switch (tripStatusStepModel.stepIndex) {
              case 0:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(widget.tripModel,
                        TripStatus.HEADING_TO_PICKUP_POINT.name, true,
                        openMapWidget: false));
                break;
              case 1:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(widget.tripModel,
                        TripStatus.ARRIVED_TO_PICKUP_POINT.name, true,
                        openMapWidget: false));

                break;
              case 2:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(widget.tripModel,
                        TripStatus.HEADING_TO_DESTINATION.name, true,
                        openMapWidget: false));
                break;
              case 3:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(
                        widget.tripModel, TripStatus.TRIP_COMPLETED.name, true,
                        isLastStep: true, openMapWidget: false));
                break;
            }
          },
          onStepTapped: (int index) {},
          steps: <stepper.CustomStep>[
            stepper.CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 0,
                continueIconWidget: Image.asset(ImageAssets.driveIc),
                state: tripStatusStepModel.stepIndex > 0
                    ? stepper.StepState.complete
                    : stepper.StepState.indexed,
                title: Text(
                  tripStepperTitles(
                      TripStatus.READY_FOR_TAKEOFF.name,
                      driverServiceType.isNotEmpty
                          ? driverServiceType
                          : TripTypeConstants.personsType,
                      _appPreferences
                          .getCachedDriver()!
                          .captainType
                          .toString()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: Container(),
                continueButtonLabel:
                    widget.tripModel.tripDetails.date != null ||
                            _appPreferences.getCachedDriver()!.captainType ==
                                RegistrationConstants.businessOwner
                        ? ''
                        : AppStrings.movedToClient.tr(),
                cancelButtonLabel: ''),
            stepper.CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 1,
                continueIconWidget: Image.asset(ImageAssets.navigationIc),
                state: tripStatusStepModel.stepIndex > 1
                    ? stepper.StepState.complete
                    : stepper.StepState.indexed,
                title: Text(
                  tripStepperTitles(
                      TripStatus.HEADING_TO_PICKUP_POINT.name,
                      driverServiceType.isNotEmpty
                          ? driverServiceType
                          : TripTypeConstants.personsType,
                      _appPreferences
                          .getCachedDriver()!
                          .captainType
                          .toString()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: widget.tripModel.tripDetails.date != null
                    ? Container()
                    : Container(
                        child: Text(
                          _appPreferences
                                      .getCachedDriver()!
                                      .captainType
                                      .toString() ==
                                  RegistrationConstants.captain
                              ? currentEstimatedTime
                              : tripStepperDisc(
                                  TripStatus.HEADING_TO_PICKUP_POINT.name,
                                  driverServiceType.isNotEmpty
                                      ? driverServiceType
                                      : TripTypeConstants.personsType,
                                  _appPreferences
                                      .getCachedDriver()!
                                      .captainType
                                      .toString()),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.grey1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s12),
                        ),
                      ),
                continueButtonLabel:
                    widget.tripModel.tripDetails.date != null ||
                            _appPreferences.getCachedDriver()!.captainType ==
                                RegistrationConstants.businessOwner
                        ? ''
                        : AppStrings.youArrivedPickupLocation.tr(),
                cancelButtonLabel: ''),
            stepper.CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 2,
                continueIconWidget: Image.asset(ImageAssets.driveIc),
                state: tripStatusStepModel.stepIndex > 2
                    ? stepper.StepState.complete
                    : stepper.StepState.indexed,
                title: Text(
                  tripStepperTitles(
                      TripStatus.ARRIVED_TO_PICKUP_POINT.name,
                      driverServiceType.isNotEmpty
                          ? driverServiceType
                          : TripTypeConstants.personsType,
                      _appPreferences
                          .getCachedDriver()!
                          .captainType
                          .toString()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: widget.tripModel.tripDetails.date != null
                    ? Container()
                    : Container(
                        child: Text(
                          tripStepperDisc(
                              TripStatus.ARRIVED_TO_PICKUP_POINT.name,
                              driverServiceType.isNotEmpty
                                  ? driverServiceType
                                  : TripTypeConstants.personsType,
                              _appPreferences
                                  .getCachedDriver()!
                                  .captainType
                                  .toString()),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.grey1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s12),
                        ),
                      ),
                continueButtonLabel:
                    widget.tripModel.tripDetails.date != null ||
                            _appPreferences.getCachedDriver()!.captainType ==
                                RegistrationConstants.businessOwner
                        ? ''
                        : AppStrings.headingToDestinationPoint.tr(),
                cancelButtonLabel: ''),
            stepper.CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 3,
                continueIconWidget: Image.asset(ImageAssets.tripFinishIc),
                continueButtonBGColor: ColorManager.secondaryColor,
                state: tripStatusStepModel.stepIndex > 3
                    ? stepper.StepState.complete
                    : stepper.StepState.indexed,
                title: Text(
                  tripStepperTitles(
                      TripStatus.HEADING_TO_DESTINATION.name,
                      driverServiceType.isNotEmpty
                          ? driverServiceType
                          : TripTypeConstants.personsType,
                      _appPreferences
                          .getCachedDriver()!
                          .captainType
                          .toString()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: widget.tripModel.tripDetails.date != null
                    ? Container()
                    : Container(
                        child: Text(
                          tripStepperDisc(
                              TripStatus.HEADING_TO_DESTINATION.name,
                              driverServiceType.isNotEmpty
                                  ? driverServiceType
                                  : TripTypeConstants.personsType,
                              _appPreferences
                                  .getCachedDriver()!
                                  .captainType
                                  .toString()),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.grey1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s12),
                        ),
                      ),
                continueButtonLabel: widget.tripModel.tripDetails.tripStatus !=
                        TripStatus.TRIP_COMPLETED.name
                    ? widget.tripModel.tripDetails.date != null ||
                            _appPreferences.getCachedDriver()!.captainType ==
                                RegistrationConstants.businessOwner
                        ? ''
                        : AppStrings.arrivedAndCompleted.tr()
                    : '',
                cancelButtonLabel: ''),
          ],
        ),
      ),
    );
  }
}

class TripExecutionArguments {
  TripDetailsModel tripModel;

  TripExecutionArguments(this.tripModel);
}

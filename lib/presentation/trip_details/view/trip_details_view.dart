import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner_add_driver/view/assign_driver_sheet.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/presentation/google_maps/view/google_maps_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/widgets/dotted_seperator.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_details_model.dart';
import '../../../utils/ext/enums.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../coast_calculation/view/coast_caclulation_bottom_sheet.dart';
import '../../common/widgets/custom_bottom_sheet.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_button.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/trip_details_bloc.dart';
import 'more_details_widget/more_details_widget.dart';

class TripDetailsView extends StatefulWidget {
  final TripDetailsModel tripModel;

  TripDetailsView({required this.tripModel});

  @override
  State<TripDetailsView> createState() => _TripDetailsViewState();
}

class _TripDetailsViewState extends State<TripDetailsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  bool _enableSendOffer = false;
  double _driverOffer = 0.0;
  late DriverBaseModel driverBaseModel;
  bool showBusinessOwnerOfferActionsView = false;
  Driver? assignedDriverToTrip;

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
    print(widget.tripModel);
    driverBaseModel = _appPreferences.getCachedDriver()!;
    super.initState();
  }

  bottomSheetForAssignDriver(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AssignDriverBottomSheetView(
            tripId: widget.tripModel.tripDetails.tripId!,
            tripType: widget.tripModel.tripDetails.tripType!,
            onAssignDriver: (assignedDriver) {
              setState(() {
                if (assignedDriver != null) {
                  assignedDriverToTrip = assignedDriver;
                  this.showBusinessOwnerOfferActionsView = true;
                }
              });
            },
          );
        });
  }

  void _showTripRouteBottomSheet(
      LocationModel pickup, LocationModel destination) {
    CustomBottomSheet.heightWrappedBottomSheet(
      context: context,
      draggableScrollableSheet: false,
      enableDrag: false,
      items: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: GoogleMapsWidget(
            sourceLocation: pickup,
            destinationLocation: destination,
          ),
        ),
        CustomTextButton(
          text: AppStrings.back.tr(),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _showAnotherOfferBottomSheet() {
    CustomBottomSheet.heightWrappedBottomSheet(
      context: context,
      items: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInputField(
                labelText: AppStrings.sendOfferWithPrice.tr(),
                showLabelText: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${getCurrency(widget.tripModel.tripDetails.passenger?.countryCode ?? "")}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorManager.black,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty && double.parse(value) != 0.0) {
                    _enableSendOffer = true;
                    _driverOffer = double.parse(value);
                  } else {
                    _enableSendOffer = false;
                  }
                },
              ),
              CustomTextButton(
                isWaitToEnable: false,
                text: AppStrings.sendOffer.tr(),
                onPressed: () {
                  if (_enableSendOffer) {
                    CustomDialog(context).showCupertinoDialog(
                        AppStrings.confirmSendOffer.tr(),
                        AppStrings.areYouSureToSendNewOffer.tr(),
                        AppStrings.confirm.tr(),
                        AppStrings.cancel.tr(),
                        ColorManager.primary, () {
                      BlocProvider.of<TripDetailsBloc>(context).add(AddOffer(
                          _appPreferences.getCachedDriver()!.id!,
                          widget.tripModel.tripDetails.tripId!,
                          _driverOffer,
                          _appPreferences
                              .getCachedDriver()!
                              .captainType
                              .toString(),
                          driverId: assignedDriverToTrip != null
                              ? assignedDriverToTrip!.id
                              : null));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, () {
                      Navigator.pop(context);
                    });
                  } else {
                    ToastHandler(context)
                        .showToast('enter valid price', Toast.LENGTH_SHORT);
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
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
        extendAppBarIntoSafeArea: true,
        appBarForegroundColor: Colors.white,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<TripDetailsBloc, TripDetailsState>(
      listener: (context, state) {
        if (state is TripDetailsLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is TripDetailsSuccess) {}

        if (state is NewOfferSentSuccess) {
          Navigator.pop(context);
        }

        if (state is OfferAcceptedSuccess) {
          CustomDialog(context).showSuccessDialog('', '', state.message,
              onBtnPressed: () {
            Navigator.pop(context);
          });
        }
        if (state is TripDetailsFail) {
          CustomDialog(context).showErrorDialog('', '', state.message,
              onBtnPressed: () {
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerWidget(),
                    const SizedBox(height: 16),
                    _fromToWidget(),
                    const SizedBox(height: 16),
                    _showTripRouteWidget(),
                    const SizedBox(height: 20),
                    _customerInfoWidget(),
                    const SizedBox(height: 20),
                    MoreDetailsWidget(
                      transportationBaseModel: widget.tripModel.tripDetails,
                    ),
                    const SizedBox(height: 24),
                    _actionWithTripWidget(widget.tripModel),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _BoActionWithTripWidget(TripDetailsModel trip) {
    return (trip.tripDetails.acceptedOffer == null &&
            (trip.tripDetails.offers == null ||
                (trip.tripDetails.offers != null &&
                    trip.tripDetails.offers!.length >= 0)))
        ? this.showBusinessOwnerOfferActionsView
            ? _showBoTripActions()
            : CustomTextButton(
                text: AppStrings.assignDriver.tr(),
                isWaitToEnable: false,
                onPressed: () {
                  bottomSheetForAssignDriver(context);
                },
              )
        : _AcceptanceStatusWidget(trip);
  }

  Widget _showBoTripActions() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _handleAssignedDriverDetails(assignedDriverToTrip!),
          Visibility(
            visible: widget.tripModel.tripDetails.clientOffer != null &&
                (widget.tripModel.tripDetails.clientOffer != 0.0 ||
                    widget.tripModel.tripDetails.clientOffer != 0),
            child: CustomTextButton(
              text:
                  "${AppStrings.acceptRequestWith.tr()} ${widget.tripModel.tripDetails.clientOfferFormatted} ${getCurrency(widget.tripModel.tripDetails.passenger?.countryCode ?? "")}",
              onPressed: () {
                CustomBottomSheet.displayModalBottomSheetList(
                  context: context,
                  showCloseButton: true,
                  initialChildSize: 0.9,
                  customWidget: CoastCalculationBottomSheetView(
                    isAcceptOffer: true,
                    clientOfferAmount: widget.tripModel.tripDetails.clientOffer,
                    assignedDriverToTrip: assignedDriverToTrip,
                    tripId: widget.tripModel.tripDetails.tripId!,
                  ),
                );
                // BlocProvider.of<TripDetailsBloc>(context).add(AcceptOffer(
                //     _appPreferences.getCachedDriver()!.id!,
                //     widget.tripModel.tripDetails.tripId!,
                //     _appPreferences.getCachedDriver()!.captainType.toString(),
                //     driverId: assignedDriverToTrip!.id));
              },
            ),
          ),
          CustomTextButton(
            isWaitToEnable: false,
            backgroundColor: ColorManager.white,
            textColor: ColorManager.headersTextColor,
            borderColor: ColorManager.purpleMainTextColor,
            text: widget.tripModel.tripDetails.clientOffer != null &&
                    (widget.tripModel.tripDetails.clientOffer != 0.0 ||
                        widget.tripModel.tripDetails.clientOffer != 0)
                ? AppStrings.sendAnotherPrice.tr()
                : AppStrings.enterRequiredPrice.tr(),
            onPressed: () {
              CustomBottomSheet.displayModalBottomSheetList(
                context: context,
                showCloseButton: true,
                initialChildSize: 0.9,
                customWidget: CoastCalculationBottomSheetView(
                  tripId: widget.tripModel.tripDetails.tripId!,
                  assignedDriverToTrip: assignedDriverToTrip,
                ),
              );
              // _showAnotherOfferBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  Widget _handleAssignedDriverDetails(Driver driver) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "${driver.carManufacturer?.carManufacturerEn ?? ""} / ${driver.carModel?.modelName ?? ""}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${driver.firstName} ${driver.lastName} ",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
            width: 70,
            height: 50,
            child: CustomNetworkImageWidget(
                imageUrl: driver.images[0].imageUrl ?? ""))
      ],
    );
  }

  Widget _AcceptanceStatusWidget(TripDetailsModel trip) {
    return ((trip.tripDetails.offers!.isNotEmpty) &&
            (trip.tripDetails.acceptedOffer == null) &&
            trip.tripDetails.offers![0].acceptanceStatus ==
                AcceptanceType.ACCEPTED.name)
        ? Text(
            "${AppStrings.offerAccepted.tr()} ${AppStrings.waitingClientAcceptance.tr()}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorManager.primary,
                fontSize: FontSize.s16,
                fontWeight: FontWeight.bold))
        : ((trip.tripDetails.offers!.isNotEmpty) &&
                trip.tripDetails.offers![0].acceptanceStatus ==
                    AcceptanceType.PROPOSED.name)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: ColorManager.purpleMainTextColor,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                          "${AppStrings.offerHasBeenSent.tr()} (${trip.tripDetails.offers![0].driverOfferFormatted} ${getCurrency(trip.tripDetails.passenger?.countryCode ?? "")})",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.purpleMainTextColor,
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text("${AppStrings.waitingClientReplay.tr()}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.accentTextColor,
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold))
                ],
              )
            : ((trip.tripDetails.offers!.isNotEmpty) &&
                    trip.tripDetails.offers![0].acceptanceStatus ==
                        AcceptanceType.EXPIRED.name)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outlined,
                            color: ColorManager.error,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                              "${AppStrings.clientRejectYourOffer.tr()} (${trip.tripDetails.offers![0].driverOfferFormatted} ${getCurrency(trip.tripDetails.passenger?.countryCode ?? "")})",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorManager.error,
                                      fontSize: FontSize.s16,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                      CustomTextButton(
                        isWaitToEnable: false,
                        backgroundColor: ColorManager.white,
                        textColor: ColorManager.headersTextColor,
                        borderColor: ColorManager.purpleMainTextColor,
                        text: widget.tripModel.tripDetails.clientOffer !=
                                    null &&
                                (widget.tripModel.tripDetails.clientOffer !=
                                        0.0 ||
                                    widget.tripModel.tripDetails.clientOffer !=
                                        0)
                            ? AppStrings.sendAnotherPrice.tr()
                            : AppStrings.enterRequiredPrice.tr(),
                        onPressed: () {
                          CustomBottomSheet.displayModalBottomSheetList(
                            context: context,
                            showCloseButton: true,
                            initialChildSize: 0.9,
                            customWidget: CoastCalculationBottomSheetView(
                              tripId: widget.tripModel.tripDetails.tripId!,
                            ),
                          );
                          // _showAnotherOfferBottomSheet();
                        },
                      ),
                    ],
                  )
                : _acceptOrSuggestNewOfferTrip(trip);
  }

  Widget _acceptOrSuggestNewOfferTrip(TripDetailsModel trip) {
    return ((driverBaseModel.captainType ==
                RegistrationConstants.businessOwner) &&
            (trip.tripDetails.offers != null &&
                trip.tripDetails.offers!.isEmpty))
        ? _BoActionWithTripWidget(trip)
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: widget.tripModel.tripDetails.clientOffer != null &&
                      (widget.tripModel.tripDetails.clientOffer != 0.0 ||
                          widget.tripModel.tripDetails.clientOffer != 0),
                  child: CustomTextButton(
                    text:
                        "${AppStrings.acceptRequestWith.tr()} ${widget.tripModel.tripDetails.clientOfferFormatted} (${AppStrings.rs.tr()})",
                    onPressed: () {
                      CustomBottomSheet.displayModalBottomSheetList(
                        context: context,
                        showCloseButton: true,
                        initialChildSize: 0.9,
                        customWidget: CoastCalculationBottomSheetView(
                          isAcceptOffer: true,
                          clientOfferAmount:
                              widget.tripModel.tripDetails.clientOffer,
                          tripId: widget.tripModel.tripDetails.tripId!,
                        ),
                      );
                      // BlocProvider.of<TripDetailsBloc>(context).add(AcceptOffer(
                      //     _appPreferences.getCachedDriver()!.id!,
                      //     widget.tripModel.tripDetails.tripId!,
                      //     _appPreferences
                      //         .getCachedDriver()!
                      //         .captainType
                      //         .toString()));
                    },
                  ),
                ),
                CustomTextButton(
                  isWaitToEnable: false,
                  backgroundColor: ColorManager.white,
                  textColor: ColorManager.headersTextColor,
                  borderColor: ColorManager.purpleMainTextColor,
                  text: widget.tripModel.tripDetails.clientOffer != null &&
                          (widget.tripModel.tripDetails.clientOffer != 0.0 ||
                              widget.tripModel.tripDetails.clientOffer != 0)
                      ? AppStrings.sendAnotherPrice.tr()
                      : AppStrings.enterRequiredPrice.tr(),
                  onPressed: () {
                    CustomBottomSheet.displayModalBottomSheetList(
                      context: context,
                      showCloseButton: true,
                      initialChildSize: 0.9,
                      customWidget: CoastCalculationBottomSheetView(
                        tripId: widget.tripModel.tripDetails.tripId!,
                      ),
                    );
                    // _showAnotherOfferBottomSheet();
                  },
                ),
              ],
            ),
          );
  }

  Widget _actionWithTripWidget(TripDetailsModel trip) {
    return (trip.tripDetails.acceptedOffer == null &&
                trip.tripDetails.offers == null ||
            (trip.tripDetails.offers != null &&
                trip.tripDetails.offers!.length >= 0))
        ? _AcceptanceStatusWidget(trip)
        : Container();
  }

  Widget _customerInfoWidget() {
    final passenger = widget.tripModel.tripDetails.passenger!;
    final initials =
        '${passenger.firstName.isNotEmpty ? passenger.firstName[0] : ''}${passenger.lastName.isNotEmpty ? passenger.lastName[0] : ''}'
            .toUpperCase();
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
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: ColorManager.splashBGColor.withOpacity(0.15),
                child: Text(
                  initials.isNotEmpty ? initials : '?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.splashBGColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.from.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorManager.formHintTextColor,
                            fontSize: FontSize.s12,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${passenger.firstName} ${passenger.lastName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorManager.headersTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.tripModel.tripDetails.clientOffer != null &&
              (widget.tripModel.tripDetails.clientOffer != 0.0 ||
                  widget.tripModel.tripDetails.clientOffer != 0)) ...[
            const SizedBox(height: 16),
            _IconTextDataWidget(
                "${AppStrings.withBudget.tr()} ${widget.tripModel.tripDetails.clientOfferFormatted.toString()}",
                ImageAssets.tripDetailsVisaIcon),
          ],
          const SizedBox(height: 12),
          _IconTextDataWidget(
              widget.tripModel.tripDetails.date != null
                  ? "${AppStrings.scheduled.tr()} ${widget.tripModel.tripDetails.date!.getTimeStampFromDate()}"
                  : "${AppStrings.asSoonAsPossible.tr()}",
              ImageAssets.tripDetailsAsapIcon),
        ],
      ),
    );
  }

  Widget _IconTextDataWidget(String data, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          iconPath,
          width: AppSize.s18,
          height: AppSize.s18,
        ),
        SizedBox(
          width: AppSize.s14,
        ),
        Text(
          data,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.headersTextColor,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
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
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
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

  Widget _headerWidget() {
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
              Icon(
                Icons.trip_origin_rounded,
                size: 22,
                color: ColorManager.splashBGColor,
              ),
              SizedBox(
                height: 36,
                child: DashLineView(
                  fillRate: .88,
                  direction: Axis.vertical,
                  dashColor: ColorManager.borderColor,
                  dashWith: 6,
                ),
              ),
              Icon(
                Icons.location_on_rounded,
                size: 22,
                color: ColorManager.splashBGColor,
              ),
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
                const SizedBox(height: 20),
                Text(
                  "${AppStrings.to.tr()} ${widget.tripModel.tripDetails.destinationLocation.locationName}",
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

  Widget _showTripRouteWidget() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showTripRouteBottomSheet(
              LocationModel(
                  locationName:
                      widget.tripModel.tripDetails.pickupLocation.locationName!,
                  latitude:
                      widget.tripModel.tripDetails.pickupLocation.latitude!,
                  longitude:
                      widget.tripModel.tripDetails.pickupLocation.longitude!),
              LocationModel(
                  locationName: widget
                      .tripModel.tripDetails.destinationLocation.locationName!,
                  latitude: widget
                      .tripModel.tripDetails.destinationLocation.latitude!,
                  longitude: widget
                      .tripModel.tripDetails.destinationLocation.longitude!));
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: ColorManager.splashBGColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: ColorManager.splashBGColor.withOpacity(0.35),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.map_rounded,
                size: 22,
                color: ColorManager.splashBGColor,
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.showTripRoute.tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorManager.splashBGColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripDetailsArguments {
  TripDetailsModel tripModel;

  TripDetailsArguments({required this.tripModel});
}

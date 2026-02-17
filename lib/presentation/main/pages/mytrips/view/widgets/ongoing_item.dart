import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';

import '../../../../../../app/app_prefs.dart';
import '../../../../../../app/di.dart';
import '../../../../../../domain/model/driver_model.dart';
import '../../../../../../domain/model/trip_details_model.dart';
import '../../../../../../utils/ext/enums.dart';
import '../../../../../../utils/resources/assets_manager.dart';
import '../../../../../../utils/resources/color_manager.dart';
import '../../../../../../utils/resources/constants_manager.dart';
import '../../../../../../utils/resources/font_manager.dart';
import '../../../../../../utils/resources/routes_manager.dart';
import '../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../utils/resources/values_manager.dart';
import '../../../../../common/widgets/custom_card.dart';
import '../../../../../trip_execution/view/trip_execution_view.dart';
import '../../bloc/my_trips_bloc.dart';

class OngoingItemView extends StatefulWidget {
  TripDetailsModel trip;
  String currentTripModelId;
  String date;

  OngoingItemView(
      {required this.trip,
      required this.currentTripModelId,
      required this.date});

  @override
  State<OngoingItemView> createState() => _OngoingItemViewState();
}

class _OngoingItemViewState extends State<OngoingItemView> {
  String driverServiceType = "";
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    driverServiceType = _appPreferences.getCachedDriver()!.captainType ==
            RegistrationConstants.captain
        ? (_appPreferences.getCachedDriver()! as Driver).serviceTypes!.first
        : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 20,
      onClick: () {
        Navigator.pushNamed(context, Routes.tripExecution,
                arguments: TripExecutionArguments(widget.trip))
            .then((value) => BlocProvider.of<MyTripsBloc>(context)
                .add(GetTripsTripModuleId(widget.currentTripModelId)));
      },
      bodyWidget: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorManager.splashBGColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorManager.splashBGColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        widget.trip.tripDetails.date != null &&
                                widget.trip.tripDetails.date != ""
                            ? ImageAssets.scheduledTripIc
                            : ImageAssets.asSoonAsPossibleTripIc,
                        width: AppSize.s16,
                        height: AppSize.s16,
                        color: ColorManager.splashBGColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.date != null && widget.date != ""
                            ? AppStrings.scheduled.tr() +
                                " ${widget.date.getTimeStampFromDate()}"
                            : AppStrings.asSoonAsPossible.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorManager.splashBGColor,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ColorManager.splashBGColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    getIconName(widget.trip.tripDetails.tripType!),
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              getTitle(widget.trip.tripDetails.tripType!),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "${widget.trip.tripDetails.pickupLocation.locationName} – ${widget.trip.tripDetails.destinationLocation.locationName}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.formHintTextColor,
                  fontSize: FontSize.s12,
                  height: 1.35),
            ),
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: ColorManager.lineColor.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              tripStepperTitles(
                  widget.trip.tripDetails.tripStatus.toString(),
                  driverServiceType.isNotEmpty ? driverServiceType : "PERSONS",
                  _appPreferences.getCachedDriver()!.captainType.toString()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: getTripStatusDisColor(
                      widget.trip.tripDetails.tripStatus.toString()),
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.w700),
            ),
            if (tripStepperDisc(
                    widget.trip.tripDetails.tripStatus.toString(),
                    driverServiceType.isNotEmpty
                        ? driverServiceType
                        : "PERSONS",
                    _appPreferences.getCachedDriver()!.captainType.toString())
                .isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                tripStepperDisc(
                    widget.trip.tripDetails.tripStatus.toString(),
                    driverServiceType.isNotEmpty
                        ? driverServiceType
                        : "PERSONS",
                    _appPreferences.getCachedDriver()!.captainType.toString()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorManager.titlesTextColor,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

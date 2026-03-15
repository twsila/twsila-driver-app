import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/rate_passenger/view/rate_passenger_view.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../../../../domain/model/trip_details_model.dart';
import '../../../../../../utils/ext/enums.dart';
import '../../../../../../utils/resources/assets_manager.dart';
import '../../../../../../utils/resources/color_manager.dart';
import '../../../../../../utils/resources/font_manager.dart';
import '../../../../../../utils/resources/routes_manager.dart';
import '../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../utils/resources/values_manager.dart';
import '../../../../../common/widgets/custom_card.dart';
import '../../../../../trip_execution/view/trip_execution_view.dart';
import '../../bloc/my_trips_bloc.dart';

class PrecedentItemView extends StatefulWidget {
  TripDetailsModel trip;
  String currentTripModelId;
  String date;

  PrecedentItemView(
      {required this.trip,
      required this.currentTripModelId,
      required this.date});

  @override
  State<PrecedentItemView> createState() => _PrecedentItemViewState();
}

class _PrecedentItemViewState extends State<PrecedentItemView> {
  AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 20,
      onClick: () {},
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 18,
                      color: ColorManager.splashBGColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${widget.trip.tripDetails.passenger!.firstName} ${widget.trip.tripDetails.passenger!.lastName}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.payment_rounded,
                      size: 18,
                      color: ColorManager.splashBGColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${widget.trip.tripDetails.paymentValue} ${getCurrency(widget.trip.tripDetails.passenger?.countryCode ?? "")}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: ColorManager.lineColor.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              widget.trip.tripDetails.completionDate != null
                  ? "${AppStrings.tripCompletedInDay.tr()} "
                      "${widget.trip.tripDetails.completionDate?.getTimeStampFromDate() ?? "-"}"
                  : '${AppStrings.tripCompletedInDay.tr()} -',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.w700),
            ),
            if (widget.trip.tripDetails.driverRating != null &&
                widget.trip.tripDetails.driverRating != -1.0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: ColorManager.splashBGColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${AppStrings.passengerWasRatedBy.tr()} ${widget.trip.tripDetails.driverRating}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ] else if (_appPreferences.getCachedDriver()!.captainType ==
                RegistrationConstants.captain) ...[
              const SizedBox(height: 12),
              CustomTextButton(
                text: AppStrings.ratePassenger.tr(),
                isWaitToEnable: false,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.ratePassenger,
                      arguments: RatePassengerArguments(widget.trip));
                },
                margin: 0,
                backgroundColor: ColorManager.splashBGColor,
                textColor: Colors.white,
                icon: const Icon(
                  Icons.star_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}






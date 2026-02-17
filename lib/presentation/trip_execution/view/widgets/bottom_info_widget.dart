import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxi_for_you/domain/model/trip_details_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_expected_time_to_arrive_widget.dart';
import '../../../common/widgets/custom_text_button.dart';
import '../../../trip_details/widgets/dotted_seperator.dart';

class BottomInfoWidget extends StatefulWidget {
  TripDetailsModel tripModel;

  BottomInfoWidget({required this.tripModel});

  @override
  State<BottomInfoWidget> createState() => _BottomInfoWidgetState();
}

class _BottomInfoWidgetState extends State<BottomInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          color: ColorManager.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_fromToWidget()],
          )),
    ]);
    ;
  }

  Widget _fromToWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: AppSize.s8,
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color: ColorManager.primary,
                  ),
                  Container(
                    height: AppSize.s36,
                    child: DashLineView(
                      fillRate: .88,
                      direction: Axis.vertical,
                    ),
                  ),
                  SvgPicture.asset(ImageAssets.locationPinTripDetailsIc)
                ],
              ),
              SizedBox(
                width: AppSize.s10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${AppStrings.from.tr()} ${widget.tripModel.tripDetails.pickupLocation.locationName}",
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: ColorManager.headersTextColor,
                                    fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          "الوقت المتوقع 15 دقيقة",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSize.s18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${AppStrings.to.tr()} ${widget.tripModel.tripDetails.destinationLocation.locationName}",
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: ColorManager.headersTextColor,
                                    fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // ExpectedTimeToArriveWidget(
                        //   destinationLocationToEstimateFromCurrentLocation:
                        //       LocationModel(
                        //     latitude: widget.tripModel.tripDetails
                        //         .destinationLocation.latitude!,
                        //     longitude: widget.tripModel.tripDetails
                        //         .destinationLocation.longitude!,
                        //     locationName: widget.tripModel.tripDetails
                        //         .destinationLocation.locationName!,
                        //   ),
                        // ),
                        Text(
                          "الوقت المتوقع 5 دقيقة",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          CustomTextButton(
            text: AppStrings.callClient.tr(),
            isWaitToEnable: false,
            onPressed: () {
              launchUrl(Uri(
                  scheme: 'tel',
                  path:
                      '${widget.tripModel.tripDetails.passenger!.mobile.toString()}'));
            },
            icon: Icon(
              Icons.call,
              color: ColorManager.white,
            ),
          )
        ],
      ),
    );
  }
}

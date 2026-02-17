import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:taxi_for_you/domain/model/trip_details_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/rate_passenger/bloc/rate_passenger_bloc.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/dialogs/custom_dialog.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class RatePassengerView extends StatefulWidget {
  TripDetailsModel tripDetailsModel;

  RatePassengerView({required this.tripDetailsModel});

  @override
  State<RatePassengerView> createState() => _RatePassengerViewState();
}

class _RatePassengerViewState extends State<RatePassengerView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;

  double rating = 3;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    print(widget.tripDetailsModel);
    super.initState();
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
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          appBarTitle: AppStrings.tripHasBeenCompleted.tr(),
          centerTitle: true,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          appBarActions: [
            widget.tripDetailsModel.tripDetails.tripNumber != null
                ? FittedBox(
                    child: Container(
                      width: 120,
                      margin: EdgeInsets.symmetric(
                          vertical: AppMargin.m16, horizontal: AppMargin.m16),
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p12, vertical: AppPadding.p8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: ColorManager.primaryPurple, width: 2)),
                      child: Center(
                        child: Text(
                          widget.tripDetailsModel.tripDetails.tripNumber ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s20),
                        ),
                      ),
                    ),
                  )
                : Container()
          ]),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<RatePassengerBloc, RatePassengerState>(
      listener: (context, state) {
        if (state is RatePassengerLoading) {
          startLoading();
        } else {
          stopLoading();
        }

        if (state is RatePassengerSuccess) {
          Navigator.pushReplacementNamed(context, Routes.mainRoute);
        }
        if (state is RatePassengerFail) {
          CustomDialog(context).showErrorDialog("", "", state.errorMessage);
        }
      },
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              SizedBox(
                height: AppSize.s55,
              ),
              Image.asset(ImageAssets.ratePassengerGraphic),
              Text(
                AppStrings.pleaseRatePassenger.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s24),
              ),
              Text(
                "${AppStrings.trip.tr()} ${getTitle(widget.tripDetailsModel.tripDetails.tripType.toString())}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s22),
              ),
              Text(
                "${widget.tripDetailsModel.tripDetails.pickupLocation.locationName} - ${widget.tripDetailsModel.tripDetails.destinationLocation.locationName}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.titlesTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s16),
              ),
              FittedBox(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: AppMargin.m16, horizontal: AppMargin.m16),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p12, vertical: AppPadding.p8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: ColorManager.dividerColor, width: 1)),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppPadding.p4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: ColorManager.primaryBlueBackgroundColor,
                        ),
                        child: Image.asset(
                          ImageAssets.tripDetailsProfileIc,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${AppStrings.withK.tr()} ${widget.tripDetailsModel.tripDetails.passenger?.firstName ?? ""} ${widget.tripDetailsModel.tripDetails.passenger?.lastName ?? ""}",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: ColorManager.headersTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.s16),
                      ),
                    ],
                  ),
                ),
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  this.rating = rating;
                },
              ),
              Spacer(),
              CustomTextButton(
                text: AppStrings.confirmAndFinish.tr(),
                isWaitToEnable: false,
                onPressed: () {
                  BlocProvider.of<RatePassengerBloc>(context).add(RatePassenger(
                      _appPreferences.getCachedDriver()!.id!,
                      widget.tripDetailsModel.tripDetails.tripId!,
                      rating));
                },
                backgroundColor: ColorManager.primary,
                textColor: ColorManager.white,
              )
            ],
          ),
        );
      },
    );
  }
}

class RatePassengerArguments {
  TripDetailsModel tripDetailsModel;

  RatePassengerArguments(this.tripDetailsModel);
}

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/presentation/google_maps/model/maps_repo.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';

import '../../../../app/constants.dart';
import '../../../../domain/model/location_filter_model.dart';
import '../../../../utils/dialogs/toast_handler.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/routes_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_text_button.dart';
import '../../../google_maps/model/location_model.dart';
import '../../../google_maps/view/google_places_field.dart';
import '../../../location_bloc/location_bloc.dart';
import '../../../trip_execution/helper/location_helper.dart';

class CityFilterWidget extends StatefulWidget {
  final Function(Destination? pickup, Destination? destination,
      CurrentLocationFilter currentLocation) onSelectLocationFilter;

  CityFilterWidget({required this.onSelectLocationFilter});

  @override
  State<CityFilterWidget> createState() => _CityFilterWidgetState();
}

class _CityFilterWidgetState extends State<CityFilterWidget> {
  bool isCitySelected = false;
  bool isCurrentCitySelected = false;
  bool _loadingLocation = true;
  bool _loadingSubmit = false;

  Prediction? pPickup;
  Prediction? pDestination;

  Destination? pickup;
  Destination? destination;
  CurrentLocationFilter? currentLocationFilter;

  LocationModel? currentLocation;

  final TextEditingController _searchFromController = TextEditingController();
  final TextEditingController _searchToController = TextEditingController();

  setFilterData(Destination pickup, Destination destination) {
    pickup = pickup;
    destination = destination;
  }

  @override
  void initState() {
    BlocProvider.of<LocationBloc>(context).add(getCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          _loadingLocation = true;
        } else {
          _loadingLocation = false;
        }
        if (state is CurrentLocationSuccessState) {
          currentLocation = state.currentLocation;
          currentLocationFilter = CurrentLocationFilter(
              latitude: state.currentLocation.latitude,
              longitude: state.currentLocation.longitude,
              cityName: state.currentLocation.cityName!);
        }

        if (state is CurrentLocationFailState) {
          CustomDialog(context).showCupertinoDialog(
              AppStrings.location_required.tr(),
              state.message,
              AppStrings.tryAgain.tr(),
              AppStrings.cancel.tr(),
              ColorManager.accentTextColor, () {
            if (state.locationPermission == LocationPermission.deniedForever) {
              Geolocator.openLocationSettings();
            } else {
              BlocProvider.of<LocationBloc>(context).add(getCurrentLocation());
            }
            Navigator.pop(context);
          }, () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        return _loadingLocation == false
            ? Container(
                width: double.infinity,
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
                child: isCitySelected
                    ? GestureDetector(
                        onTap: () => _showSelectCitiesDialog(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.city.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: ColorManager.headersTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: FontSize.s16),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ColorManager.splashBGColor.withOpacity(0.08),
                                border: Border.all(
                                  color: ColorManager.splashBGColor.withOpacity(0.3),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                pickup != null && destination != null
                                    ? '${AppStrings.from.tr()} ${pickup!.cityName} – ${AppStrings.to.tr()} ${destination!.cityName}'
                                    : pickup == null && destination != null
                                        ? '${AppStrings.to.tr()} ${destination!.cityName}'
                                        : pickup != null && destination == null
                                            ? '${AppStrings.from.tr()} ${pickup!.cityName}'
                                            : '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: ColorManager.splashBGColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: FontSize.s14),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.city.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: ColorManager.headersTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: FontSize.s16),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: CustomTextButton(
                              onPressed: () => _showSelectCitiesDialog(),
                              text: AppStrings.selectFromHereHint.tr(),
                              isWaitToEnable: false,
                              backgroundColor: ColorManager.splashBGColor,
                              textColor: Colors.white,
                              height: 48,
                            ),
                          ),
                        ],
                      ),
              )
            : Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorManager.borderColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.splashBGColor,
                  ),
                ),
              );
      },
    );
  }

  void _showSelectCitiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return _dialogContentWidget(setState);
              },
            ),
          ),
        );
      },
    ).then((value) => (setState(() {})));
  }

  Widget _dialogContentWidget(StateSetter setState) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.7,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.from.tr()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.titlesTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s16),
              ),
              SizedBox(
                height: 10,
              ),
              GoogleMapsPlacesField(
                enabled: !isCurrentCitySelected,
                controller: _searchFromController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: "${AppStrings.pleaseEnterCity.tr()}",
                predictionCallback: (prediction) async {
                  if (prediction != null) {
                    setState(() {
                      _loadingLocation == true;
                    });
                    _searchFromController.text = await LocationHelper()
                        .getCityNameByCoordinates(
                            double.tryParse(prediction.lat!)!,
                            double.tryParse(prediction.lng!)!);
                    pPickup = prediction;
                    pickup = Destination(
                        latitude: double.parse(prediction.lat!),
                        longitude: double.parse(prediction.lng!),
                        cityName: _searchFromController.text);
                    setState(() {
                      _loadingLocation == false;
                    });
                  } else {}
                },
              ),
              Text(
                '${AppStrings.to.tr()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.titlesTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s16),
              ),
              SizedBox(
                height: 10,
              ),
              GoogleMapsPlacesField(
                enabled: !isCurrentCitySelected,
                controller: _searchToController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: "${AppStrings.pleaseEnterCity.tr()}",
                predictionCallback: (prediction) async {
                  if (prediction != null) {
                    setState(() {
                      _loadingLocation == true;
                    });
                    _searchToController.text = await LocationHelper()
                        .getCityNameByCoordinates(
                            double.tryParse(prediction.lat!)!,
                            double.tryParse(prediction.lng!)!);
                    pDestination = prediction;
                    destination = Destination(
                        latitude: double.parse(prediction.lat!),
                        longitude: double.parse(prediction.lng!),
                        cityName: _searchToController.text);
                    setState(() {
                      _loadingLocation == false;
                    });
                  } else {}
                },
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Checkbox(
                    side: BorderSide(
                        color: ColorManager.secondaryColor,
                        width: AppSize.s1_5),
                    activeColor: ColorManager.secondaryColor,
                    focusColor: ColorManager.primary,
                    checkColor: ColorManager.white,
                    value: isCurrentCitySelected,
                    onChanged: (value) {
                      setState(() {
                        isCurrentCitySelected = value!;
                        if (isCurrentCitySelected) {
                          if (currentLocation != null) {
                            pickup = Destination(
                                latitude: currentLocation!.latitude,
                                longitude: currentLocation!.longitude,
                                cityName: currentLocation!.cityName!);
                            destination = Destination(
                                latitude: currentLocation!.latitude,
                                longitude: currentLocation!.longitude,
                                cityName: currentLocation!.cityName!);
                          } else {
                            BlocProvider.of<LocationBloc>(context)
                                .add(getCurrentLocation());
                          }
                        } else if (_searchFromController.text.isNotEmpty &&
                            _searchToController.text.isNotEmpty &&
                            pPickup != null &&
                            pDestination != null) {
                          pickup = Destination(
                              latitude: double.parse(pPickup!.lat!),
                              longitude: double.parse(pPickup!.lng!),
                              cityName: _searchFromController.text);
                          destination = Destination(
                              latitude: double.parse(pDestination!.lat!),
                              longitude: double.parse(pDestination!.lng!),
                              cityName: _searchToController.text);
                        }
                      });
                    },
                  ),
                  Text(
                    AppStrings.currentCity.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.titlesTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16),
                  ),
                ],
              ),
              CustomTextButton(
                text: _loadingSubmit
                    ? AppStrings.loading.tr()
                    : AppStrings.confirm.tr(),
                isWaitToEnable: false,
                backgroundColor: ColorManager.secondaryColor,
                textColor: ColorManager.white,
                onPressed: _loadingSubmit
                    ? null
                    : () {
                        if (pickup != null ||
                            destination != null &&
                                currentLocationFilter != null) {
                          widget.onSelectLocationFilter(
                              pickup, destination, currentLocationFilter!);
                          isCitySelected = true;
                          Navigator.pop(context);
                        } else {
                          ToastHandler(context)
                              .showToast(AppStrings.pleaseEnterCity.tr(), null);
                        }
                      },
              ),
              CustomTextButton(
                text: AppStrings.back.tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

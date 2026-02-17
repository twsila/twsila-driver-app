import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_checkbox_datetime_now.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_date_picker.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../utils/location/map_provider.dart';
import '../model/location_model.dart';
import 'google_maps_widget.dart';
import 'google_places_field.dart';

class GoogleSearchScreen extends StatefulWidget {
  final TextEditingController sourceController;
  final TextEditingController destinationController;
  final Function(String? date)? onSelectDate;
  final Function(LocationModel? source) onSelectSource;
  final Function(LocationModel? destination) onSelectDestination;

  const GoogleSearchScreen({
    Key? key,
    required this.sourceController,
    required this.destinationController,
    required this.onSelectSource,
    required this.onSelectDestination,
    this.onSelectDate,
  }) : super(key: key);

  @override
  State<GoogleSearchScreen> createState() => GoogleSearchScreenState();
}

class GoogleSearchScreenState extends State<GoogleSearchScreen> {
  LocationModel? sourceLocation;
  LocationModel? destinationLocation;
  bool _isInit = true;
  bool _isChecked = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      LocationModel? currentLocation =
          Provider.of<MapProvider>(context, listen: false).currentLocation;
      if (currentLocation != null && sourceLocation == null) {
        widget.sourceController.text = currentLocation.locationName;
        sourceLocation = currentLocation;
        widget.onSelectSource(sourceLocation);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.onSelectDate != null
            ? Column(
                children: [
                  CustomCheckboxDateTimeNow(
                    isChecked: _isChecked,
                    onSelectDate: widget.onSelectDate!,
                    onCheckedChanged: (checked) {
                      setState(() {
                        _isChecked = checked;
                      });
                    },
                  ),
                  if (!_isChecked)
                    CustomDatePickerWidget(
                      onSelectDate: widget.onSelectDate!,
                      pickTime: true,
                    )
                ],
              )
            : const SizedBox(),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Text(
                AppStrings.sourcePoint.tr(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 3,
              child: GoogleMapsPlacesField(
                controller: widget.sourceController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: AppStrings.sourceHint.tr(),
                predictionCallback: (prediction) {
                  if (prediction != null) {
                    sourceLocation = LocationModel(
                      locationName: prediction.description!,
                      latitude: double.parse(prediction.lat!),
                      longitude: double.parse(prediction.lng!),
                    );
                  } else {
                    sourceLocation = null;
                  }
                  widget.onSelectSource(sourceLocation);
                  Provider.of<MapProvider>(context, listen: false).setLocation(
                    sourceLocation: sourceLocation,
                    destinationLocation: destinationLocation,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Text(
                AppStrings.destinationPoint.tr(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 3,
              child: GoogleMapsPlacesField(
                controller: widget.destinationController,
                focusNode: FocusNode(debugLabel: 'destination_node'),
                hintText: AppStrings.destinationHint.tr(),
                predictionCallback: (prediction) {
                  if (prediction != null) {
                    destinationLocation = LocationModel(
                      locationName: prediction.description!,
                      latitude: double.parse(prediction.lat!),
                      longitude: double.parse(prediction.lng!),
                    );
                  } else {
                    destinationLocation = null;
                  }
                  widget.onSelectDestination(destinationLocation);
                  Provider.of<MapProvider>(context, listen: false).setLocation(
                      sourceLocation: sourceLocation,
                      destinationLocation: destinationLocation);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
            child: GoogleMapsWidget(
          sourceLocation: sourceLocation,
          destinationLocation: destinationLocation,
        )),
      ],
    );
  }
}

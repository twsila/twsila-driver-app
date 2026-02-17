import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';

class ExpectedTimeToArriveWidget extends StatefulWidget {
  final LocationModel destinationLocationToEstimateFromCurrentLocation;

  ExpectedTimeToArriveWidget(
      {required this.destinationLocationToEstimateFromCurrentLocation});

  @override
  State<ExpectedTimeToArriveWidget> createState() =>
      _ExpectedTimeToArriveWidgetState();
}

class _ExpectedTimeToArriveWidgetState
    extends State<ExpectedTimeToArriveWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        AppStrings.twselaCaptian.tr(),
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: ColorManager.primary, fontSize: FontSize.s12),
      ),
    );
  }
}

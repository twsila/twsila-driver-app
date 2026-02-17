import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/model/water_model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import 'item_widget.dart';

class WaterDetailsWidget extends StatelessWidget {
  final WaterModel waterModel;
  const WaterDetailsWidget({
    Key? key,
    required this.waterModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemWidget(
          title: AppStrings.waterTankSize.tr(),
          text: waterModel.tankSize != null
              ? waterModel.tankSize!.value
              : "-",
        ),
      ],
    );
  }
}

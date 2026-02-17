import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';

import '../../../../../domain/model/persons_model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import 'item_widget.dart';

class PersonDetailsWidget extends StatelessWidget {
  final PersonsModel personsModel;

  const PersonDetailsWidget({Key? key, required this.personsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppPreferences appPreferences = instance<AppPreferences>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemWidget(
                title: AppStrings.vehicleType.tr(),
                text: appPreferences.getAppLanguage() == "ar"
                    ? personsModel.vehicleType?.vehicleTypeAr ?? "-"
                    : personsModel.vehicleType?.vehicleType ?? "-",
              ),
            ),
            Expanded(
              child: ItemWidget(
                title: AppStrings.numOfPassengers.tr(),
                text: personsModel.numberOfPassengers?.numberOfPassengers
                        .toString() ??
                    "-",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

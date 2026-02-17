import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/model/freezers-model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import 'frozen_extra_services.dart';
import 'item_widget.dart';

class FrozenDetailsWidget extends StatelessWidget {
  final FreezersModel freezersModel;

  const FrozenDetailsWidget({
    Key? key,
    required this.freezersModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemWidget(
                title: AppStrings.shippedTypes.tr(),
                text: freezersModel.shippedType != null
                    ? freezersModel.shippedType!.value
                    : "-",
              ),
            ),
            Expanded(
              child: ItemWidget(
                title: AppStrings.materialsTobeShipped.tr(),
                text: freezersModel.frozenType != null
                    ? freezersModel.frozenType!.value
                    : "-",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FrozenExtraServices(freezersModel: freezersModel),
      ],
    );
  }
}

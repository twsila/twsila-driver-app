import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/model/cisterns_model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import 'item_widget.dart';


class CisternsDetailsWidget extends StatelessWidget {
  final CisternsModel cisternsModel;
  const CisternsDetailsWidget({
    Key? key,
    required this.cisternsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemWidget(
          title: AppStrings.cisternsType.tr(),
          text: cisternsModel.cisternsType != null
              ? cisternsModel.cisternsType!.value
              : "-",
        ),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/goods_details_widget/widgets/goods_extra_services.dart';

import '../../../../../../domain/model/goods_model.dart';
import '../../../../../../utils/resources/color_manager.dart';
import '../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../utils/resources/styles_manager.dart';

class GoodsDetailsWidget extends StatelessWidget {
  final GoodsModel goodsModel;

  const GoodsDetailsWidget({
    Key? key,
    required this.goodsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: ColorManager.lineColor),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: itemWidget(
                AppStrings.materialTypes.tr(),
                goodsModel.materialType?.value ?? '',
              ),
            ),
            Expanded(
              child: itemWidget(
                AppStrings.selectPackagingTypes.tr(),
                goodsModel.packingType?.value ?? '',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GoodsExtraServices(goodsModel: goodsModel),
            ),
            Expanded(
              child: itemWidget(
                AppStrings.goodsWeight.tr(),
                goodsModel.payloadWeight?.toInt().toString() ?? "-",
              ),
            )
          ],
        )
      ],
    );
  }
}

Widget itemWidget(String title, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        textAlign: TextAlign.start,
        style: getMediumStyle(
          color: ColorManager.titlesTextColor,
          fontSize: 16,
        ),
      ),
      Text(
        text,
        textAlign: TextAlign.start,
        style: getBoldStyle(
          color: ColorManager.headersTextColor,
          fontSize: 16,
        ),
      ),
    ],
  );
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/model/goods_model.dart';
import '../../../../../../../utils/resources/color_manager.dart';
import '../../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../../utils/resources/styles_manager.dart';

class GoodsExtraServices extends StatelessWidget {
  final GoodsModel goodsModel;
  const GoodsExtraServices({
    Key? key,
    required this.goodsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (goodsModel.containsLift == true ||
            goodsModel.containsLoading == true ||
            goodsModel.containsPacking == true)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.extraServices.tr(),
                textAlign: TextAlign.start,
                style: getMediumStyle(
                  color: ColorManager.titlesTextColor,
                  fontSize: 16,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (goodsModel.containsLift)
                      Text(
                        AppStrings.crane.tr(),
                        textAlign: TextAlign.start,
                        style: getBoldStyle(
                          color: ColorManager.headersTextColor,
                          fontSize: 16,
                        ),
                      ),
                    if (goodsModel.containsLoading)
                      Text(
                        AppStrings.unloadAndLoad.tr(),
                        textAlign: TextAlign.start,
                        style: getBoldStyle(
                          color: ColorManager.headersTextColor,
                          fontSize: 16,
                        ),
                      ),
                    if (goodsModel.containsPacking)
                      Text(
                        AppStrings.wrapping.tr(),
                        textAlign: TextAlign.start,
                        style: getBoldStyle(
                          color: ColorManager.headersTextColor,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              )
            ],
          )
        : const SizedBox();
  }
}

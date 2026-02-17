import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/model/furniture_model.dart';
import '../../../../../../../utils/resources/color_manager.dart';
import '../../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../../utils/resources/styles_manager.dart';

class FurnitureExtraItems extends StatefulWidget {
  final FurnitureModel furnitureModel;
  const FurnitureExtraItems({
    Key? key,
    required this.furnitureModel,
  }) : super(key: key);

  @override
  State<FurnitureExtraItems> createState() => _FurnitureExtraItemsState();
}

class _FurnitureExtraItemsState extends State<FurnitureExtraItems> {
  List<String> itemsMap = [];

  @override
  void initState() {
    initializeMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return itemsMap.isNotEmpty
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
                  children: List.generate(itemsMap.length, (index) {
                    return Text(
                      itemsMap[index] +
                          ((itemsMap.length != index + 1) ? ' / ' : ''),
                      textAlign: TextAlign.start,
                      style: getBoldStyle(
                        color: ColorManager.headersTextColor,
                        fontSize: 16,
                      ),
                    );
                  }),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  initializeMap() {
    if (widget.furnitureModel.containsAssemble) {
      itemsMap.add(AppStrings.assemble.tr());
    }
    if (widget.furnitureModel.containsLift) {
      itemsMap.add(AppStrings.crane.tr());
    }
    if (widget.furnitureModel.containsPacking) {
      itemsMap.add(AppStrings.wrapping.tr());
    }
    if (widget.furnitureModel.containsLoading) {
      itemsMap.add(AppStrings.unloadAndLoad.tr());
    }
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/model/furniture_model.dart';
import '../../../../../../../utils/resources/color_manager.dart';
import '../../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../../utils/resources/styles_manager.dart';
import 'furniture_details_text.dart';

class FurnitureTransportItems extends StatefulWidget {
  final FurnitureItems furnitureItems;

  const FurnitureTransportItems({
    Key? key,
    required this.furnitureItems,
  }) : super(key: key);

  @override
  State<FurnitureTransportItems> createState() =>
      _FurnitureTransportItemsState();
}

class _FurnitureTransportItemsState extends State<FurnitureTransportItems> {
  Map<String, String> itemsMap = {};

  @override
  void initState() {
    initializeItemMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            AppStrings.transporationItems.tr(),
            textAlign: TextAlign.start,
            style: getMediumStyle(
              color: ColorManager.titlesTextColor,
              fontSize: 16,
            ),
          ),
        ),
        Wrap(
          children: List.generate(itemsMap.length, (index) {
            var keys = itemsMap.keys.toList();
            var val = itemsMap[keys[index]];
            return FurnitureDetailsText(
              title: keys[index],
              text: val!,
              addBackSlash: itemsMap.length != index + 1,
            );
          }),
        ),
      ],
    );
  }

  initializeItemMap() {
    if (widget.furnitureItems.roomsNumber != 0) {
      itemsMap[AppStrings.roomsNumber.tr()] =
          widget.furnitureItems.roomsNumber.toInt().toString();
    }
    if (widget.furnitureItems.fridgeNumber != 0) {
      itemsMap[AppStrings.fridgeNumber.tr()] =
          widget.furnitureItems.fridgeNumber.toInt().toString();
    }
    if (widget.furnitureItems.carpetNumber != 0) {
      itemsMap[AppStrings.carpetsNumber.tr()] =
          widget.furnitureItems.carpetNumber.toInt().toString();
    }
    if (widget.furnitureItems.diningRoomNumber != 0) {
      itemsMap[AppStrings.dinningRoomsNumber.tr()] =
          widget.furnitureItems.diningRoomNumber.toInt().toString();
    }
    if (widget.furnitureItems.kitchenNumber != 0) {
      itemsMap[AppStrings.kitchenNumber.tr()] =
          widget.furnitureItems.kitchenNumber.toInt().toString();
    }
    if (widget.furnitureItems.sofaSetNumber != 0) {
      itemsMap[AppStrings.sofaSetNumber.tr()] =
          widget.furnitureItems.sofaSetNumber.toInt().toString();
    }
    if (widget.furnitureItems.splitAirconditionerNumber != 0) {
      itemsMap[AppStrings.splitAirconditionerNumber.tr()] =
          widget.furnitureItems.splitAirconditionerNumber.toInt().toString();
    }
    if (widget.furnitureItems.tablesNumber != 0) {
      itemsMap[AppStrings.tablesNumber.tr()] =
          widget.furnitureItems.tablesNumber.toInt().toString();
    }
    if (widget.furnitureItems.windowAirconditionerNumber != 0) {
      itemsMap[AppStrings.windowAirconditionerNumber.tr()] =
          widget.furnitureItems.windowAirconditionerNumber.toInt().toString();
    }
    if (widget.furnitureItems.other != 0) {
      itemsMap[AppStrings.other.tr()] =
          widget.furnitureItems.other.toInt().toString();
    }
  }
}

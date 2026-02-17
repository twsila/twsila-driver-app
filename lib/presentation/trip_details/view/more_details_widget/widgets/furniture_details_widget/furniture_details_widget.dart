import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/furniture_details_widget/widgets/furniture_extra_service.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/furniture_details_widget/widgets/furniture_transport_items.dart';

import '../../../../../../domain/model/furniture_model.dart';
import '../../../../../../utils/resources/color_manager.dart';

class FurnitureDetailsWidget extends StatelessWidget {
  final FurnitureModel furnitureModel;
  const FurnitureDetailsWidget({
    Key? key,
    required this.furnitureModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: ColorManager.lineColor),
        FurnitureTransportItems(
          furnitureItems: furnitureModel.furnitureItems,
        ),
        const SizedBox(height: 8),
        FurnitureExtraItems(furnitureModel: furnitureModel)
      ],
    );
  }
}

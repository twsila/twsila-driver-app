import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/styles_manager.dart';
import 'custom_bottom_sheet.dart';
import 'custom_search_bottomsheet.dart';

class DestinationPointWidget extends StatefulWidget {
  final Function(String lat, String long, String locationName)
      onSelectDestinPlace;
  final String? destinLocationString;

  const DestinationPointWidget({
    Key? key,
    required this.onSelectDestinPlace,
    this.destinLocationString,
  }) : super(key: key);

  @override
  _DestinationPointWidgetState createState() => _DestinationPointWidgetState();
}

class _DestinationPointWidgetState extends State<DestinationPointWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CustomBottomSheet.displayModalBottomSheetList(
          context: context,
          showCloseButton: false,
          initialChildSize: 0.9,
          customWidget: CustomSearchBottomsheet(
            title: 'AppStrings.selectDeliveryPoint.tr()',
            onSelectPlace: widget.onSelectDestinPlace,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.secondaryAccentColor),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Icon(Icons.pin),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.destinLocationString ??
                    'AppStrings.selectDeliveryPoint.tr()',
                style: getBoldStyle(
                    color: ColorManager.titlesTextColor, fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            widget.destinLocationString == null
                ? Icon(
                    Icons.arrow_forward,
                    color: ColorManager.primary,
                  )
                : Icon(Icons.check_circle,color: ColorManager.primary,)
          ],
        ),
      ),
    );
  }
}

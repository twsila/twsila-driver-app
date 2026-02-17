import 'package:flutter/material.dart';

import '../../../../../../../utils/resources/color_manager.dart';
import '../../../../../../../utils/resources/styles_manager.dart';


class FurnitureDetailsText extends StatelessWidget {
  final String title;
  final String text;
  final bool addBackSlash;
  const FurnitureDetailsText({
    Key? key,
    required this.title,
    required this.text,
    this.addBackSlash = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title + ': ',
          style:
              getBoldStyle(color: ColorManager.headersTextColor, fontSize: 14),
        ),
        Text(
          text,
          style:
              getBoldStyle(color: ColorManager.headersTextColor, fontSize: 14),
        ),
        if (addBackSlash)
          Text(
            ' / ',
            style: getBoldStyle(
                color: ColorManager.headersTextColor, fontSize: 14),
          ),
      ],
    );
  }
}

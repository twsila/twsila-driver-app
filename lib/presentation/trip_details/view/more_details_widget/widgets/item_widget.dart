import 'package:flutter/material.dart';

import '../../../../../utils/resources/color_manager.dart';
import '../../../../../utils/resources/styles_manager.dart';


class ItemWidget extends StatelessWidget {
  final String title;
  final String text;
  const ItemWidget({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    ;
  }
}

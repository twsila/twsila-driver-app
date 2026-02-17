import 'package:flutter/material.dart';

import '../../../utils/resources/color_manager.dart';


class CustomCircularProgressIndicator extends StatelessWidget {
  final double? size;
  const CustomCircularProgressIndicator({Key? key, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 32,
      width: size ?? 32,
      child: CircularProgressIndicator(
        color: ColorManager.accentColor,
        backgroundColor: ColorManager.primary,
      ),
    );
  }
}

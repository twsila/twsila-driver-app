import 'package:flutter/material.dart';

import '../../../utils/resources/color_manager.dart';

class CustomCard extends StatelessWidget {
  final Widget bodyWidget;
  final Color? backgroundColor;
  final Function() onClick;
  final double? borderRadius;

  const CustomCard({
    Key? key,
    required this.bodyWidget,
    this.backgroundColor,
    required this.onClick,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 16.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(radius),
        splashColor: ColorManager.primary.withOpacity(0.06),
        highlightColor: ColorManager.primary.withOpacity(0.03),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? ColorManager.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: ColorManager.borderColor.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.headersTextColor.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: bodyWidget,
            ),
          ),
        ),
      ),
    );
  }
}

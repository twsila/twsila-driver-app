import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';

class CustomTextOutlinedButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color? backgroundColor;
  final double? height;
  const CustomTextOutlinedButton({
    Key? key,
    this.backgroundColor,
    this.height,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: Border.all(
            color: ColorManager.primary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: const EdgeInsets.all(16),
        height: height,
        child: Center(
          child: Text(
            text,
            style: getMediumStyle(color: ColorManager.primary, fontSize: 22),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

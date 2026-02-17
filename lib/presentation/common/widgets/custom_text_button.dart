import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';

import '../../../utils/resources/values_manager.dart';

class CustomTextButton extends StatefulWidget {
  final Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? margin;
  final Widget? icon;
  final Color? iconColor;
  final bool isWaitToEnable;
  final double? fontSize;
  final BorderRadius? borderRadius;

  const CustomTextButton({
    Key? key,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.height,
    this.width,
    this.margin,
    this.icon,
    this.iconColor,
    this.onPressed,
    this.isWaitToEnable = true,
    this.fontSize,
    this.borderRadius,
    required this.text,
  }) : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    return InkWell(
      onTap: (widget.onPressed != null) ? widget.onPressed : null,
      borderRadius: radius,
      child: Container(
        margin: EdgeInsets.all(widget.margin ?? AppMargin.m12),
        width: widget.width ?? double.infinity,
        height: widget.height ?? AppSize.s50,
        decoration: BoxDecoration(
            color: widget.isWaitToEnable
                ? widget.onPressed != null
                    ? ColorManager.primary
                    : ColorManager.disableBackgroundColor
                : widget.backgroundColor ?? ColorManager.primary,
            border: Border.all(
                color: widget.borderColor ??
                    ((widget.onPressed != null)
                        ? ColorManager.buttonTextColor
                        : Colors.transparent)),
            borderRadius: radius),
        child: Center(
          child: widget.icon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: getBoldStyle(
                              color: widget.isWaitToEnable
                                  ? widget.onPressed != null
                                      ? widget.textColor != null
                                          ? widget.textColor!
                                          : ColorManager.buttonTextColor
                                      : ColorManager.disableTextColor
                                  : widget.textColor != null
                                      ? widget.textColor!
                                      : ColorManager.buttonTextColor,
                              fontSize: widget.fontSize ?? FontSize.s16),
                        ),
                        const SizedBox(
                          width: AppSize.s12,
                        ),
                        widget.icon!,
                      ],
                    ),
                  ),
                )
              : Text(
                  widget.text,
                  style: getBoldStyle(
                      color: widget.isWaitToEnable
                          ? widget.onPressed != null
                              ? widget.textColor != null
                                  ? widget.textColor!
                                  : ColorManager.buttonTextColor
                              : ColorManager.disableTextColor
                          : widget.textColor != null
                              ? widget.textColor!
                              : ColorManager.buttonTextColor,
                      fontSize: widget.fontSize ?? FontSize.s16),
                ),
        ),
      ),
    );
  }
}

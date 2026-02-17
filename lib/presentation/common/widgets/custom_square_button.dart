import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/values_manager.dart';

class CustomSquareButton extends StatefulWidget {
  final Function() onPressed;
  final IconData iconData;
  final String text;
  final double? height;
  final double? width;

  const CustomSquareButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.iconData,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<CustomSquareButton> createState() => _CustomSquareButtonState();
}

class _CustomSquareButtonState extends State<CustomSquareButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width ?? context.getWidth() / 3,
        height: widget.height ?? 120,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.iconData,
                size: AppSize.s32,
                color: Colors.white,
              ),
              const SizedBox(
                width: AppSize.s14,
              ),
              Text(
                widget.text,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

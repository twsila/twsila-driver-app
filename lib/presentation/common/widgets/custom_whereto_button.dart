import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

class CustomWhereToButton extends StatelessWidget {
  final Function()? onPressed;
  const CustomWhereToButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 1.0),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Where To?',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: ColorManager.primary,
                      fontSize: 14,
                    ),
              ),
              Icon(
                Icons.search,
                color: ColorManager.primary,
                size: 18,
              ),
            ],
          ),
        ));
  }
}

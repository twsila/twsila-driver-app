import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

import '../../../utils/resources/color_manager.dart';

class CustomBackButton extends StatefulWidget {
  final Function() onPressed;

  const CustomBackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Icon(
        Icons.arrow_back_ios_sharp,
        color: ColorManager.black,
      ),
    );
  }
}

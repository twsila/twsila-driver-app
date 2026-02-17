import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/helpers/language_helper.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

class CustomCountDownTimer extends StatefulWidget {
  final Function onTimerFinished;

  const CustomCountDownTimer({Key? key, required this.onTimerFinished})
      : super(key: key);

  @override
  _CustomCountDownTimerState createState() => _CustomCountDownTimerState();
}

class _CustomCountDownTimerState extends State<CustomCountDownTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = Constants.otpCountTime;

  AppPreferences appPreferences = instance();

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')} : ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if(mounted){
        setState(() {
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();
            widget.onTimerFinished();
          }
        });
      }
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          LanguageHelper().replaceArabicNumber(timerText),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ColorManager.blackTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s16,
              ),
        ),
        const SizedBox(
          width: AppSize.s2,
        ),
        Text(
          AppStrings.second.tr(),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ColorManager.blackTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s16,
              ),
        ),
      ],
    );
  }
}

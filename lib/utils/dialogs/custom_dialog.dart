import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class CustomDialog {
  BuildContext context;

  CustomDialog(this.context);

  showErrorDialog(String? title, String? desc, String body,
      {Function()? onBtnPressed}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      body: Center(
        child: Text(
          body,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: AppSize.s16),
        ),
      ),
      title: title ?? "",
      titleTextStyle: Theme.of(context).textTheme.displayMedium,
      desc: desc ?? "",
      buttonsBorderRadius: BorderRadius.circular(12),
      btnOkColor: ColorManager.secondaryColor,
      descTextStyle: Theme.of(context).textTheme.displayMedium,
      btnOkOnPress: onBtnPressed ?? () {},
    ).show();
  }

  showWaringDialog(String? title, String? desc, String body,
      {Function()? onBtnPressed}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: Text(
          body,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: AppSize.s16),
        ),
      ),
      title: title ?? "",
      titleTextStyle: Theme.of(context).textTheme.displayMedium,
      desc: desc ?? "",
      buttonsBorderRadius: BorderRadius.circular(12),
      btnOkColor: ColorManager.secondaryColor,
      descTextStyle: Theme.of(context).textTheme.displayMedium,
      btnOkOnPress: onBtnPressed ?? () {},
    ).show();
  }

  showSuccessDialog(String? title, String? desc, String body,
      {Function()? onBtnPressed}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      body: Center(
        child: Text(
          body,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: AppSize.s16),
        ),
      ),
      title: title ?? "",
      titleTextStyle: Theme.of(context).textTheme.displayMedium,
      desc: desc ?? "",
      buttonsBorderRadius: BorderRadius.circular(12),
      btnOkColor: ColorManager.primary,
      btnOkText: AppStrings.ok.tr(),
      descTextStyle: Theme.of(context).textTheme.displayMedium,
      btnOkOnPress: onBtnPressed ?? () {},
    ).show();
  }

  showCupertinoDialog(
      String title,
      String content,
      String defaultActionButtonText,
      String secondButtonText,
      Color defaultActionTextColor,
      Function() onDefaultActionButtonPressed,
      Function() onSecondButtonPressed) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: new Text(
                content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold, fontSize: FontSize.s12),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    defaultActionButtonText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: defaultActionTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: onDefaultActionButtonPressed,
                ),
                CupertinoDialogAction(
                  child: Text(
                    secondButtonText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorManager.secondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: onSecondButtonPressed,
                )
              ],
            ));
  }

  void showCustomDialog(BuildContext context, Widget bodyWidget) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Center(child: Material(child: Container(child: bodyWidget)));
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}

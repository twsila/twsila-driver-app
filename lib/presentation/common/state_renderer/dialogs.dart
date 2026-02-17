import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class ShowDialogHelper {
  static void showErrorMessage(String message, BuildContext context) {
    final fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: ColorManager.error,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: FontConstants.fontFamily,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccessMessage(String message, BuildContext context) {
    final fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: FontConstants.fontFamily,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showDialogPopupWithCancel(String title, String message,
      BuildContext context, Function cancelFunc, Function okFunc,
      {String? okText, Widget? messageWidget, bool dismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: ColorManager.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSize.s18,
              fontWeight: FontWeightManager.bold,
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.headersTextColor,
            ),
          ),
          content: SingleChildScrollView(
            child: messageWidget ??
                Text(
                  message,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightManager.regular,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.grey,
                  ),
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppStrings.cancel.tr(),
                style: TextStyle(
                  color: ColorManager.headersTextColor,
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: FontConstants.fontFamily,
                ),
              ),
              onPressed: () {
                cancelFunc();
              },
            ),
            TextButton(
              child: Text(
                okText ?? AppStrings.confirm.tr(),
                style: TextStyle(
                  color: ColorManager.splashBGColor,
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: FontConstants.fontFamily,
                ),
              ),
              onPressed: () {
                okFunc();
              },
            ),
          ],
        ),
      ),
    );
  }
}

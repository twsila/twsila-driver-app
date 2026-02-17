import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class DialogUtils {
  static void showNotificationPopup(
      BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                body,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomTextButton(
                text: AppStrings.ok.tr(),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

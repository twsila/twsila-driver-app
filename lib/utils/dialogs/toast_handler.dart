import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../resources/color_manager.dart';

class ToastHandler {
  BuildContext context;

  ToastHandler(this.context);

  showToast(String message, Toast? length) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: length ?? Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorManager.primary,
        textColor: ColorManager.white,
        fontSize: 16.0);
  }
}

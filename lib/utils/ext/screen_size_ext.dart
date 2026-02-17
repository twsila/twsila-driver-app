import 'package:flutter/material.dart';

extension ScreenSize on BuildContext {
  double getWidth() {
    return MediaQuery.of(this).size.width;
  }

  double getHeight() {
    return MediaQuery.of(this).size.height;
  }

  double getWidthPercentagePadding(num ratio) {
    return (ratio * MediaQuery.of(this).size.width) / 100;
  }

  double getHeightPercentagePadding(num ratio) {
    return (ratio * MediaQuery.of(this).size.height) / 100;
  }
}

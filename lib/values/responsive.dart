import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late MediaQueryData _mediaQueryData;
  late double screenWidth;
  late double screenHeight;

  Responsive(this.context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  // Scale width (based on design width of 375)
  double wp(double value) {
    return (value / 375.0) * screenWidth;
  }

  // Scale height (based on design height of 812)
  double hp(double value) {
    return (value / 812.0) * screenHeight;
  }

  // Scale font size (adaptive based on width and height average)
  double sp(double fontSize) {
    double scaleFactor = (screenWidth + screenHeight) / 2;
    return fontSize * (scaleFactor / 1200); // balanced for phones and tablets
  }
}

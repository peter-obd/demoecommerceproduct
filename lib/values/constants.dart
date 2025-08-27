import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagesConstants {
  static const String splashImage = 'assets/images/splashImage.png';
}

class AppTextStyle {
  static TextStyle titleStyle(double fontSize, {Color? color}) {
    return GoogleFonts.raleway(
      fontWeight: FontWeight.w900,
      fontSize: fontSize,
      color: color ?? Colors.white,
    );
  }

  static TextStyle textStyle(
      double fontSize, Color color, FontWeight fontWeight) {
    return GoogleFonts.raleway(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }
}

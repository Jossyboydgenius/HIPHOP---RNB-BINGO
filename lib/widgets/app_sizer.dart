import 'package:flutter/material.dart';

class AppDimension {
  static late MediaQueryData mediaQuery;
  static late double height;
  static late double width;
  static late bool isSmall;
  static late bool isTablet;

  static void init(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    isSmall = height < 700 && width < 400;
    isTablet = width > 600;
  }
} 
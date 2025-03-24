import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimension {
  static late MediaQueryData mediaQuery;
  static late double height;
  static late double width;
  static late bool isSmall;
  static late bool isTablet;

  static void init(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    height = 812.h;  // Match design height
    width = 375.w;   // Match design width
    isSmall = height < 700.h && width < 400.w;
    isTablet = width > 600.w;
  }
} 
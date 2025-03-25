import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimension {
  static late MediaQueryData mediaQuery;
  static late double height;
  static late double width;
  static late bool isSmall;
  static late bool isTablet;
  static late double scaleFactor;
  // static late bool isEnlarged;
  // static late double textScaleFactor;
  static void init(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    isSmall = height < 700 || width < 375;
    isTablet = width > 600;
    
    // Calculate scale factor based on design size (375, 812)
    double heightFactor = height / 812;
    double widthFactor = width / 375;
    scaleFactor = (heightFactor + widthFactor) / 2;
  }

  static double getScaledSize(double size) {
    return size * scaleFactor;
  }

  static double getResponsiveHeight(double height) {
    return isSmall ? height * 0.8 : height;
  }

  static double getResponsiveWidth(double width) {
    return isSmall ? width * 0.9 : width;
  }

  static EdgeInsets getResponsivePadding(EdgeInsets padding) {
    if (!isSmall) return padding;
    return EdgeInsets.only(
      left: padding.left * 0.9,
      right: padding.right * 0.9,
      top: padding.top * 0.8,
      bottom: padding.bottom * 0.8,
    );
  }

  static double getFontSize(double size) {
    if (isSmall) {
      return (size * 0.85).sp;
    }
    return size.sp;
  }
}

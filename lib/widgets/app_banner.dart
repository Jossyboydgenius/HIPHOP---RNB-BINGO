import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_banner_painter.dart';

class AppBanner extends StatelessWidget {
  final String text;
  final Color fillColor;
  final Color borderColor;
  final TextStyle textStyle;
  final double width;
  final double height;
  final bool hasShadow;
  final Color shadowColor;
  final double shadowBlurRadius;

  const AppBanner({
    super.key,
    required this.text,
    required this.fillColor,
    required this.borderColor,
    required this.textStyle,
    this.width = 194,
    this.height = 38,
    this.hasShadow = false,
    this.shadowColor = Colors.black38,
    this.shadowBlurRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width.w, height.h),
            painter: AppBannerPainter(
              fillColor: fillColor,
              borderColor: borderColor,
              hasShadow: hasShadow,
              shadowColor: shadowColor,
              shadowBlurRadius: shadowBlurRadius.r,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
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
      width: width,
      height: height,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: AppBannerPainter(
              fillColor: fillColor,
              borderColor: borderColor,
              hasShadow: hasShadow,
              shadowColor: shadowColor,
              shadowBlurRadius: shadowBlurRadius,
            ),
          ),
          // Center the text both horizontally and vertically
          Center(
            child: Padding(
              // Add a slight padding to account for the banner's curved edges
              padding: const EdgeInsets.only(bottom: 2),
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
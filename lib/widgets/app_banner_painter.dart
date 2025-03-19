import 'package:flutter/material.dart';

class AppBannerPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  AppBannerPainter({
    required this.fillColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ... existing paint code ...
  }

  @override
  bool shouldRepaint(AppBannerPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor || 
           oldDelegate.borderColor != borderColor;
  }
} 
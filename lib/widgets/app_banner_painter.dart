import 'package:flutter/material.dart';

class AppBannerPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final bool hasShadow;
  final Color shadowColor;
  final double shadowBlurRadius;

  AppBannerPainter({
    required this.fillColor,
    required this.borderColor,
    this.hasShadow = false,
    this.shadowColor = Colors.black38,
    this.shadowBlurRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scale factors based on the original dimensions (194x38)
    final scaleX = size.width / 194;
    final scaleY = size.height / 38;

    // Main banner path
    Path path = Path();
    path.moveTo(7.01141 * scaleX, 1 * scaleY);
    path.lineTo(187.209 * scaleX, 1 * scaleY);
    path.cubicTo(
      193.046 * scaleX, 1 * scaleY,
      195.446 * scaleX, 8.48838 * scaleY,
      190.698 * scaleX, 11.8817 * scaleY
    );
    path.lineTo(186.641 * scaleX, 14.7803 * scaleY);
    path.cubicTo(
      183.292 * scaleX, 17.1734 * scaleY,
      183.292 * scaleX, 22.1507 * scaleY,
      186.641 * scaleX, 24.5437 * scaleY
    );
    path.lineTo(190.698 * scaleX, 27.4424 * scaleY);
    path.cubicTo(
      195.446 * scaleX, 30.8357 * scaleY,
      193.046 * scaleX, 38.3241 * scaleY,
      187.209 * scaleX, 38.3241 * scaleY
    );
    path.lineTo(7.01143 * scaleX, 38.3241 * scaleY);
    path.cubicTo(
      1.17502 * scaleX, 38.3241 * scaleY,
      -1.22559 * scaleX, 30.8357 * scaleY,
      3.523 * scaleX, 27.4424 * scaleY
    );
    path.lineTo(7.57938 * scaleX, 24.5437 * scaleY);
    path.cubicTo(
      10.9281 * scaleX, 22.1507 * scaleY,
      10.9282 * scaleX, 17.1734 * scaleY,
      7.57938 * scaleX, 14.7803 * scaleY
    );
    path.lineTo(3.52301 * scaleX, 11.8817 * scaleY);
    path.cubicTo(
      -1.22559 * scaleX, 8.48838 * scaleY,
      1.175 * scaleX, 1 * scaleY,
      7.01141 * scaleX, 1 * scaleY
    );
    path.close();

    // Draw shadow if enabled
    if (hasShadow) {
      Paint shadowPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);
      canvas.drawPath(path, shadowPaint);
    }

    // Fill the main shape
    Paint mainPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawPath(path, mainPaint);

    // Draw border
    if (borderColor.opacity > 0) {
      Paint borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = borderColor
        ..strokeWidth = 2;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(AppBannerPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
           oldDelegate.borderColor != borderColor ||
           oldDelegate.hasShadow != hasShadow ||
           oldDelegate.shadowColor != shadowColor ||
           oldDelegate.shadowBlurRadius != shadowBlurRadius;
  }
} 
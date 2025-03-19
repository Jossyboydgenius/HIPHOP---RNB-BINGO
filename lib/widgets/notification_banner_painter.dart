import 'package:flutter/material.dart';

class NotificationBannerPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  NotificationBannerPainter({
    required this.fillColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Draw the main shape
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.1, 0);
    path.lineTo(size.width * 0.9, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw the border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(NotificationBannerPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor || 
           oldDelegate.borderColor != borderColor;
  }
} 
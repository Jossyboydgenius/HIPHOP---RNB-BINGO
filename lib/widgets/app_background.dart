import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base black background
        Container(
          color: Colors.black,
        ),

        // Top left primary circle
        Positioned(
          top: -40,
          left: -80,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
        ),

        // Top right accent circle
        Positioned(
          top: -40,
          right: -140,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.5),
            ),
          ),
        ),

        // Bottom primary circle
        Positioned(
          bottom: -250,
          left: -30,
          child: Container(
            width: 480,
            height: 480,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.9),
            ),
          ),
        ),

        // Blur overlay
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 50.0,
            sigmaY: 50.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // Content
        child,
      ],
    );
  }
} 
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppLoadingBar extends StatelessWidget {
  final double progress;
  final double width;
  final double height;

  const AppLoadingBar({
    super.key,
    required this.progress,
    this.width = 200,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Stack(
          children: [
            Container(
              width: width * progress,
              decoration: const BoxDecoration(
                gradient: AppColors.loadingBarGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';

class BingoButton extends StatefulWidget {
  final VoidCallback onPressed;

  const BingoButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<BingoButton> createState() => _BingoButtonState();
}

class _BingoButtonState extends State<BingoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    // Play button click sound and vibrate
    GameSoundService().playButtonClick();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: AppImages(
            imagePath: AppImageData.bingoButton,
            width: AppDimension.isSmall ? 720.w : 680.w,
            height: AppDimension.isSmall ? 200.h : 180.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

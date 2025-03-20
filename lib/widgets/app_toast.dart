import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppToast extends StatefulWidget {
  final String message;
  final VoidCallback onClose;
  final Duration duration;

  const AppToast({
    super.key,
    required this.message,
    required this.onClose,
    this.duration = const Duration(seconds: 3),
  });

  static void show(BuildContext context, String message) {
    OverlayState? overlay = Overlay.of(context);
    OverlayEntry? entry;
    
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AppToast(
            message: message,
            onClose: () {
              entry?.remove();
            },
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<AppToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onClose());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: -4,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.purpleDark,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.purplePrimary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.purpleLight,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTextStyle.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                AppImages(
                  imagePath: AppImageData.close,
                  height: 32,
                  width: 32,
                  onPressed: () {
                    _controller.reverse().then((_) => widget.onClose());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
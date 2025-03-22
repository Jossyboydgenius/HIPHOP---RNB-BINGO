import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppToast extends StatefulWidget {
  final String message;
  final VoidCallback onClose;
  final Duration duration;
  final bool showCloseIcon;
  final bool showInfoIcon;
  final Color? textColor;

  const AppToast({
    super.key,
    required this.message,
    required this.onClose,
    this.duration = const Duration(seconds: 3),
    this.showCloseIcon = true,
    this.showInfoIcon = true,
    this.textColor,
  });

  static void show(
    BuildContext context,
    String message, {
    bool showCloseIcon = true,
    bool showInfoIcon = true,
    Color? textColor,
  }) {
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
            showCloseIcon: showCloseIcon,
            showInfoIcon: showInfoIcon,
            textColor: textColor,
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
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.yellowLight2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.yellowDark4,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                if (widget.showInfoIcon)
                  const AppImages(
                    imagePath: AppImageData.info2,
                    height: 24,
                    width: 24,
                  ),
                if (widget.showInfoIcon)
                  const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTextStyle.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.textColor ?? Colors.black,
                    ),
                  ),
                ),
                if (widget.showCloseIcon)
                  AppImages(
                    imagePath: AppImageData.close,
                    height: 24,
                    width: 24,
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
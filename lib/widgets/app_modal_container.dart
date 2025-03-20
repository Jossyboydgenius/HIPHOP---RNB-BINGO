import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_banner.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'app_text_style.dart';

class AppModalContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final double? width;
  final double? height;
  final Color? fillColor;
  final Color? borderColor;
  final Color? layerColor;
  final double borderWidth;
  final double borderRadius;
  final String? title;
  final TextStyle? titleStyle;
  final double layerTopPosition;
  final Widget? customTitle;
  final AppBanner? banner;
  final bool maintainFocus;

  const AppModalContainer({
    super.key,
    required this.child,
    required this.onClose,
    this.width,
    this.height,
    this.fillColor,
    this.borderColor,
    this.layerColor,
    this.borderWidth = 5,
    this.borderRadius = 32,
    this.title,
    this.titleStyle,
    this.customTitle,
    this.layerTopPosition = -4,
    this.banner,
    this.maintainFocus = true,
  });

  @override
  State<AppModalContainer> createState() => _AppModalContainerState();
}

class _AppModalContainerState extends State<AppModalContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.maintainFocus ? null : () => FocusScope.of(context).unfocus(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Layer behind the main container
                  if (widget.layerColor != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: widget.layerTopPosition * 3,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.layerColor,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                        ),
                      ),
                    ),
                  // Main container
                  Container(
                    width: widget.width ?? double.infinity,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: widget.fillColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: widget.borderColor ?? Colors.transparent,
                        width: widget.borderWidth,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Title bar with close button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 40),
                              if (widget.customTitle != null)
                                widget.customTitle!
                              else if (widget.title != null)
                                Text(
                                  widget.title!,
                                  style: widget.titleStyle ?? AppTextStyle.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              AppImages(
                                imagePath: AppImageData.close,
                                height: 32,
                                width: 32,
                                onPressed: _handleClose,
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: widget.child),
                      ],
                    ),
                  ),
                  // Banner on top
                  if (widget.banner != null)
                    Positioned(
                      top: -20,  // Adjust this value to position the banner
                      left: 0,
                      right: 0,
                      child: Center(child: widget.banner!),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 
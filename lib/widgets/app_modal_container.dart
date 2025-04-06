import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_banner.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'app_text_style.dart';
import 'app_sizer.dart';

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
  final bool showCloseButton;
  final bool handleBackNavigation;

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
    this.showCloseButton = true,
    this.handleBackNavigation = false,
  });

  @override
  State<AppModalContainer> createState() => _AppModalContainerState();
}

class _AppModalContainerState extends State<AppModalContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final _soundService = GameSoundService();

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
    _soundService.playBoardTap();

    await _controller.reverse();
    if (widget.handleBackNavigation) {
      Navigator.pop(context);
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.maintainFocus ? null : () => FocusScope.of(context).unfocus(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final responsiveWidth = widget.width != null
              ? AppDimension.getResponsiveWidth(widget.width!.w)
              : double.infinity;
          final responsiveHeight = widget.height != null
              ? AppDimension.getResponsiveHeight(widget.height!.h)
              : null;

          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (widget.layerColor != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: AppDimension.getScaledSize(
                              widget.layerTopPosition * 3)
                          .h,
                      height: AppDimension.getResponsiveHeight(100).h,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.layerColor,
                          borderRadius: BorderRadius.circular(
                              AppDimension.getScaledSize(widget.borderRadius)
                                  .r),
                        ),
                      ),
                    ),
                  Container(
                    width: responsiveWidth,
                    height: responsiveHeight,
                    decoration: BoxDecoration(
                      color: widget.fillColor,
                      borderRadius: BorderRadius.circular(
                          AppDimension.getScaledSize(widget.borderRadius).r),
                      border: Border.all(
                        color: widget.borderColor ?? Colors.transparent,
                        width: AppDimension.getScaledSize(widget.borderWidth).w,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (widget.showCloseButton)
                          Padding(
                            padding: AppDimension.getResponsivePadding(
                                EdgeInsets.all(16.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width:
                                        AppDimension.getResponsiveWidth(40).w),
                                if (widget.customTitle != null)
                                  widget.customTitle!
                                else if (widget.title != null)
                                  Text(
                                    widget.title!,
                                    style: widget.titleStyle ??
                                        AppTextStyle.poppins(
                                          fontSize:
                                              AppDimension.getFontSize(20),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                AppImages(
                                  imagePath: AppImageData.close,
                                  height:
                                      AppDimension.getResponsiveHeight(32).h,
                                  width: AppDimension.getResponsiveWidth(32).w,
                                  onPressed: _handleClose,
                                ),
                              ],
                            ),
                          ),
                        Expanded(child: widget.child),
                      ],
                    ),
                  ),
                  if (widget.banner != null)
                    Positioned(
                      top: AppDimension.getScaledSize(-20).h,
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

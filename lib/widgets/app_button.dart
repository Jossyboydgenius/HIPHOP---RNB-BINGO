import 'package:flutter/material.dart';
import 'app_text_style.dart';

class AppButton extends StatefulWidget {
  final String text;
  final String? subtitle;
  final VoidCallback? onPressed;
  final Color fillColor;
  final Color? layerColor;
  final double height;
  final double? width;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? layerHeight;
  final double? layerTopPosition;
  final TextStyle? textStyle;
  final TextStyle? subtitleStyle;
  final bool disabled;
  final double? fontSize;
  final double? subtitleFontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final String? fontFamily;

  const AppButton({
    super.key,
    required this.text,
    this.subtitle,
    this.onPressed,
    required this.fillColor,
    this.layerColor,
    this.height = 64,
    this.width,
    this.hasBorder = false,
    this.borderColor = Colors.white,
    this.borderWidth = 3,
    this.borderRadius = 20,
    this.layerHeight,
    this.layerTopPosition,
    this.textStyle,
    this.subtitleStyle,
    this.disabled = false,
    this.fontSize = 20,
    this.subtitleFontSize = 14,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.fontFamily,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled && widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.disabled && widget.onPressed != null) {
      _controller.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (!widget.disabled && widget.onPressed != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: widget.height,
          width: widget.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.hasBorder ? Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ) : null,
            color: widget.disabled ? widget.fillColor.withOpacity(0.5) : widget.fillColor,
          ),
          child: Stack(
            children: [
              if (widget.layerColor != null) ...[
                Positioned(
                  left: 0,
                  right: 0,
                  top: widget.layerTopPosition ?? 0,
                  height: widget.layerHeight ?? widget.height * 0.65,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      color: widget.disabled 
                          ? widget.layerColor!.withOpacity(0.5) 
                          : widget.layerColor,
                    ),
                  ),
                ),
              ],
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main text
                    widget.textStyle != null
                        ? Text(
                            widget.text,
                            style: widget.textStyle?.copyWith(
                              color: widget.disabled 
                                  ? widget.textColor?.withOpacity(0.5) 
                                  : widget.textColor,
                            ),
                          )
                        : Text(
                            widget.text,
                            style: widget.fontFamily != null
                                ? TextStyle(
                                    fontFamily: widget.fontFamily,
                                    fontSize: widget.fontSize,
                                    fontWeight: widget.fontWeight,
                                    color: widget.disabled 
                                        ? widget.textColor?.withOpacity(0.5) 
                                        : widget.textColor,
                                  )
                                : AppTextStyle.poppins(
                                    fontSize: widget.fontSize,
                                    fontWeight: widget.fontWeight,
                                    color: widget.disabled 
                                        ? widget.textColor?.withOpacity(0.5) 
                                        : widget.textColor,
                                  ),
                          ),
                    // Subtitle text if provided
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      widget.subtitleStyle != null
                          ? Text(
                              widget.subtitle!,
                              style: widget.subtitleStyle?.copyWith(
                                color: widget.disabled 
                                    ? widget.textColor?.withOpacity(0.5) 
                                    : widget.textColor,
                              ),
                            )
                          : Text(
                              widget.subtitle!,
                              style: widget.fontFamily != null
                                  ? TextStyle(
                                      fontFamily: widget.fontFamily,
                                      fontSize: widget.subtitleFontSize,
                                      color: widget.disabled 
                                          ? widget.textColor?.withOpacity(0.5) 
                                          : widget.textColor,
                                    )
                                  : AppTextStyle.poppins(
                                      fontSize: widget.subtitleFontSize,
                                      color: widget.disabled 
                                          ? widget.textColor?.withOpacity(0.5) 
                                          : widget.textColor,
                                    ),
                            ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
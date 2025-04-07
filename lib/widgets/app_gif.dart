import 'package:flutter/material.dart';

class AppGifData {
  static const _base = 'assets/gifs';

  // Gifs paths
  static const String cryingEmoji = '$_base/crying-emoji.gif';
  static const String crying = '$_base/crying.gif';
}

class AppGif extends StatelessWidget {
  final String gifPath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Animation<double>? animation;
  final AlignmentGeometry? alignment;
  final VoidCallback? onPressed;

  const AppGif({
    super.key,
    required this.gifPath,
    this.height,
    this.width,
    this.fit,
    this.animation,
    this.alignment,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget gif = Image.asset(
      gifPath,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      alignment: alignment ?? Alignment.center,
      errorBuilder: (context, error, stackTrace) {
        return _errorWidget();
      },
    );

    if (animation != null) {
      gif = ScaleTransition(
        scale: animation!,
        child: gif,
      );
    }

    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        child: gif,
      );
    }

    return gif;
  }

  Widget _errorWidget() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.withOpacity(0.4),
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.red,
        ),
      ),
    );
  }
}

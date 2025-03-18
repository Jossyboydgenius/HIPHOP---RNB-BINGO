import 'package:flutter/material.dart';

class AppImageData {
  static const _base = 'assets/images';

  // Game related images
  static const String bingo = '$_base/bingo.png';
  static const String card = '$_base/card.png';
  static const String chest = '$_base/chest.png';
  static const String coin = '$_base/coin.png';
  static const String eliminated = '$_base/eliminated.png';
  static const String gem = '$_base/gem.png';
  static const String glowing = '$_base/glowing.png';
  static const String magic = '$_base/magic.png';
  static const String medalGold = '$_base/medal-gold.png';
  static const String money = '$_base/money.png';
  static const String treasure = '$_base/treasure.png';
  static const String won = '$_base/won.png';

  // Navigation and utility images
  static const String back = '$_base/back.png';
  static const String ban = '$_base/ban.png';
  static const String mute = '$_base/mute.png';
  static const String notification = '$_base/notification.png';
  static const String time = '$_base/time.png';
  static const String user = '$_base/user.png';

  // Avatar images
  static const String image = '$_base/image.png';
  static const String image1 = '$_base/image1.png';
  static const String image2 = '$_base/image2.png';
  static const String image3 = '$_base/image3.png';
  static const String image4 = '$_base/image4.png';
  static const String image5 = '$_base/image5.png';
  static const String image6 = '$_base/image6.png';
  static const String image7 = '$_base/image7.png';
  static const String image8 = '$_base/image8.png';
  static const String image9 = '$_base/image9.png';
  static const String image10 = '$_base/image10.png';
}

class AppImages extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Animation<double>? animation;
  final AlignmentGeometry? alignment;

  const AppImages({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit,
    this.animation,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      errorBuilder: (context, error, stackTrace) {
        return _errorWidget();
      },
    );

    if (animation != null) {
      return ScaleTransition(
        scale: animation!,
        child: image,
      );
    }

    return image;
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
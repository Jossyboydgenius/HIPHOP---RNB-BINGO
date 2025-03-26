import 'package:flutter/material.dart';

class AppImageData {
  static const _base = 'assets/images';

  // Game related images
  static const String bingo = '$_base/bingo.png';
  static const String bingoo = '$_base/bingoo.png';
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
  static const String chat = '$_base/chat.png';
  static const String bingoCard = '$_base/bingo-card.png';

  // Payment options images
  static const String paypal = '$_base/paypal.png';
  static const String cashapp = '$_base/cashapp.png';
  static const String zelle = '$_base/zelle.png';

  // Navigation and utility images
  static const String back = '$_base/back.png';
  static const String ban = '$_base/ban.png';
  static const String mute = '$_base/mute.png';
  static const String notification = '$_base/notification.png';
  static const String time = '$_base/time.png';
  static const String user = '$_base/user.png';
  static const String clock = '$_base/clock.png';
  static const String map = '$_base/map.png';
  static const String gameImage = '$_base/game-image.png';
  static const String www = '$_base/www.png';
  static const String info = '$_base/info.png';
  static const String info1 = '$_base/info1.png';
  static const String info2 = '$_base/info2.png';
  static const String info3 = '$_base/info3.png';
  static const String fourCornersBingo = '$_base/four-corners-bingo.png';
  static const String blackoutBingo = '$_base/blackout-bingo.png';
  static const String straightlineBingo = '$_base/straightline-bingo.png';
  static const String tShapeBingo = '$_base/T-shape-bingo.png';
  static const String xPatternBingo = '$_base/X-pattern-bingo.png';
  static const String send = '$_base/send.png';
  static const String close = '$_base/close.png';

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

  static final Map<String, String> avatarImages = {
    'image': image,
    'image1': image1,
    'image2': image2,
    'image3': image3,
    'image4': image4,
    'image5': image5,
    'image6': image6,
    'image7': image7,
    'image8': image8,
    'image9': image9,
    'image10': image10,
  };
}

class AppImages extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Animation<double>? animation;
  final AlignmentGeometry? alignment;
  final VoidCallback? onPressed;

  const AppImages({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit,
    this.animation,
    this.alignment,
    this.onPressed,
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
      image = ScaleTransition(
        scale: animation!,
        child: image,
      );
    }

    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
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
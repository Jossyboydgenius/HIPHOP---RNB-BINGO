// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconData {
  static const String _base = 'assets/svgs';
  
  // Action icons
  static const String add = '$_base/add.svg';
  static const String add2 = '$_base/add2.svg';
  static const String edit = '$_base/edit.svg';
  static const String arrowRight = '$_base/arrowright.svg';
  static const String arrowDropdown = '$_base/arrow-dropdown.svg';
  static const String ban = '$_base/ban.svg';
  static const String mute = '$_base/mute.svg';
  static const String close = '$_base/close.svg';
  static const String send = '$_base/send.svg';
  static const String scan = '$_base/scan.svg';
  static const String password = '$_base/password.svg';

  // Game related icons
  static const String card = '$_base/card.svg';
  static const String card1 = '$_base/card1.svg';
  static const String star = '$_base/star.svg';
  static const String star1 = '$_base/star1.svg';
  static const String star2 = '$_base/star2.svg';
  static const String star3 = '$_base/star3.svg';
  static const String star4 = '$_base/star4.svg';
  static const String gem = '$_base/gem.svg';
  static const String gem1 = '$_base/gem1.svg';
  static const String glowing = '$_base/glowing.svg';
  static const String eliminated = '$_base/eliminated.svg';
  static const String won = '$_base/won.svg';
  static const String lose = '$_base/lose.svg';
  static const String medalGold = '$_base/medal-gold.svg';
  static const String magic = '$_base/magic.svg';

  // Payment and money icons
  static const String cashapp = '$_base/cashapp.svg';
  static const String paypal = '$_base/paypal.svg';
  static const String money = '$_base/money.svg';
  static const String coin = '$_base/coin.svg';
  static const String chest = '$_base/chest.svg';
  static const String treasure = '$_base/treasure.svg';

  // Social and user icons
  static const String facebook = '$_base/facebook.svg';
  static const String google = '$_base/google.svg';
  static const String apple = '$_base/apple.svg';
  static const String chat = '$_base/chat.svg';
  static const String user = '$_base/user.svg';
  static const String people = '$_base/people.svg';

  // Utility icons
  static const String notification = '$_base/notification.svg';
  static const String time = '$_base/time.svg';
  static const String info = '$_base/info.svg';
  static const String flash = '$_base/flash.svg';
  static const String image = '$_base/image.svg';
  static const String zelle = '$_base/zelle.svg';
  static const String copy = '$_base/copy.svg';
}

class AppIcons extends StatelessWidget {
  final VoidCallback? onPressed;
  final String icon;
  final double size;
  final Color? color;
  final Animation<double>? animation;
  final AlignmentGeometry? alignment;

  const AppIcons({
    super.key,
    this.onPressed,
    this.color,
    required this.icon,
    this.size = 24,
    this.animation,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = SvgPicture.asset(
      icon,
      height: size,
      width: size,
      color: color,
      alignment: alignment ?? Alignment.center,
    );

    if (animation != null) {
      iconWidget = ScaleTransition(
        scale: animation!,
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: iconWidget,
    );
  }
} 
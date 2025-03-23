import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';

class AppInAppPurchaseCard extends StatefulWidget {
  final String amount;
  final String price;
  final String plusValue;
  final VoidCallback onGetPressed;
  final String iconPath;
  final Color bannerColor;
  final bool isGemCard;

  const AppInAppPurchaseCard({
    super.key,
    required this.amount,
    required this.price,
    required this.plusValue,
    required this.onGetPressed,
    this.iconPath = AppImageData.gem,
    this.bannerColor = AppColors.pinkPrimary,
    this.isGemCard = true,
  });

  @override
  State<AppInAppPurchaseCard> createState() => _AppInAppPurchaseCardState();
}

class _AppInAppPurchaseCardState extends State<AppInAppPurchaseCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
      decoration: BoxDecoration(
        color: widget.isGemCard ? AppColors.purplePrimary : AppColors.blueLight3,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _controller,
                  child: const AppIcons(
                    icon: AppIconData.glowing,
                    size: 90,
                  ),
                ),
                AppImages(
                  imagePath: widget.iconPath,
                  width: 32,
                  height: 32,
                ),
              ],
            ),
          ),
          Text(
            '+${widget.amount}',
            textAlign: TextAlign.center,
            style: AppTextStyle.mochiyPopOne(
              fontSize: 12,
              color: widget.isGemCard ? Colors.white : AppColors.blueDark2,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          AppButton(
            text: '',
            fillColor: AppColors.yellowDark3,
            layerColor: AppColors.yellowDark2,
            height: 26,
            width: double.infinity,
            layerHeight: 22,
            layerTopPosition: -2,
            hasBorder: true,
            borderColor: Colors.white,
            borderWidth: 2,
            borderRadius: 8,
            onPressed: widget.onGetPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isGemCard 
                  ? const AppImages(
                      imagePath: AppImageData.money,
                      width: 20,
                      height: 20,
                    )
                  : const AppIcons(
                      icon: AppIconData.gem,
                      size: 12,
                    ),
                const SizedBox(width: 4),
                Text(
                  widget.isGemCard ? '\$${widget.price}' : widget.price,
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
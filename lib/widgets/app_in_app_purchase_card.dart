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

  const AppInAppPurchaseCard({
    super.key,
    required this.amount,
    required this.price,
    required this.plusValue,
    required this.onGetPressed,
    this.iconPath = AppImageData.gem,
    this.bannerColor = AppColors.pinkPrimary,
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
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.purplePrimary,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: AppColors.purpleDark,
        //   width: 2,
        // ),
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
                    size: 86,
                  ),
                ),
                AppImages(
                  imagePath: widget.iconPath,
                  width: 36,
                  height: 36,
                ),
                if (widget.plusValue.isNotEmpty)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.pinkPrimary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '+${widget.plusValue}',
                        style: AppTextStyle.dmSans(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppImages(
                  imagePath: AppImageData.money,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '\$${widget.price}',
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppButton(
            text: 'Get',
            fillColor: AppColors.yellowDark3,
            layerColor: AppColors.yellowDark2,
            height: 26,
            width: double.infinity,
            fontSize: 10,
            fontFamily: AppTextStyle.mochiyPopOneFont,
            fontWeight: FontWeight.w400,
            layerHeight: 22,
            layerTopPosition: -2,
            hasBorder: true,
            borderColor: Colors.white,
            borderWidth: 2,
            borderRadius: 8,
            onPressed: widget.onGetPressed,
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 8.h),
      decoration: BoxDecoration(
        color: widget.isGemCard ? AppColors.purplePrimary : AppColors.blueLight3,
        borderRadius: BorderRadius.circular(12.r),
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
                  child: AppIcons(
                    icon: AppIconData.glowing,
                    size: 80.w,
                  ),
                ),
                AppImages(
                  imagePath: widget.iconPath,
                  width: 32.w,
                  height: 32.h,
                ),
              ],
            ),
          ),
          Text(
            '+${widget.amount}',
            textAlign: TextAlign.center,
            style: AppTextStyle.mochiyPopOne(
              fontSize: 8.sp,
              color: widget.isGemCard ? Colors.white : AppColors.blueDark2,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          AppButton(
            text: '',
            fillColor: AppColors.yellowDark3,
            layerColor: AppColors.yellowDark2,
            height: 24.h,
            width: double.infinity,
            layerHeight: 20.h,
            layerTopPosition: -2.h,
            hasBorder: true,
            borderColor: Colors.white,
            borderWidth: 2.w,
            borderRadius: 8.r,
            onPressed: widget.onGetPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isGemCard 
                  ? AppImages(
                      imagePath: AppImageData.money,
                      width: 16.w,
                      height: 16.h,
                    )
                  : AppIcons(
                      icon: AppIconData.gem,
                      size: 12.w,
                    ),
                SizedBox(width: 4.w),
                Text(
                  widget.isGemCard ? '\$${widget.price}' : widget.price,
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: 8.sp,
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
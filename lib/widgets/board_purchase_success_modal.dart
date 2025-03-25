import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';

class BoardPurchaseSuccessModal extends StatefulWidget {
  final VoidCallback onClose;
  final String amount;

  const BoardPurchaseSuccessModal({
    super.key,
    required this.onClose,
    required this.amount,
  });

  @override
  State<BoardPurchaseSuccessModal> createState() => _BoardPurchaseSuccessModalState();
}

class _BoardPurchaseSuccessModalState extends State<BoardPurchaseSuccessModal> with SingleTickerProviderStateMixin {
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
      color: Colors.black,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppModalContainer(
                width: double.infinity,
                height: AppDimension.isSmall ? 600.h : 300.h,
                fillColor: AppColors.purplePrimary,
                borderColor: AppColors.purpleLight,
                layerColor: AppColors.purpleDark,
                layerTopPosition: -4.h,
                borderRadius: AppDimension.isSmall ? 32.r : 24.r,
                showCloseButton: false,
                onClose: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: AppDimension.isSmall ? 20.h : 20.h),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        RotationTransition(
                          turns: _controller,
                          child: AppIcons(
                            icon: AppIconData.glowing,
                            size: AppDimension.isSmall ? 150.w : 150.w,
                          ),
                        ),
                        AppImages(
                          imagePath: AppImageData.card,
                          width: AppDimension.isSmall ? 90.w : 90.w,
                          height: AppDimension.isSmall ? 90.h : 90.h,
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimension.isSmall ? 6.h : 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${widget.amount}',
                          style: AppTextStyle.textWithStroke(
                            fontSize: AppDimension.isSmall ? 78.sp : 68.sp,
                            textColor: AppColors.deepPurple,
                            strokeColor: Colors.white,
                            strokeWidth: AppDimension.isSmall ? 8.w : 6.w,
                            fontFamily: AppTextStyle.poppinsFont,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Added',
                      style: AppTextStyle.textWithStroke(
                        fontSize: AppDimension.isSmall ? 16.sp : 12.sp,
                        textColor: Colors.white,
                        strokeColor: AppColors.darkPurple3,
                        strokeWidth: AppDimension.isSmall ? 6.w : 5.w,
                        fontFamily: AppTextStyle.mochiyPopOneFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimension.isSmall ? 50.h : 40.h),
              SizedBox(
                width: AppDimension.isSmall ? 180.w : 180.w,
                child: AppButton(
                  text: 'Continue',
                  textStyle: AppTextStyle.poppins(
                    fontSize: AppDimension.isSmall ? 16.sp : 16.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  fillColor: AppColors.darkPurple,
                  layerColor: AppColors.darkPurple2,
                  height: AppDimension.isSmall ? 70.h : 50.h,
                  layerHeight: AppDimension.isSmall ? 55.h : 42.h,
                  layerTopPosition: -2.h,
                  hasBorder: true,
                  borderColor: Colors.white,
                  onPressed: widget.onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
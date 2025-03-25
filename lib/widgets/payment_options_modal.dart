import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_images.dart';

class PaymentOptionsModal extends StatelessWidget {
  final VoidCallback onClose;
  final Function(String) onPaymentSelected;
  final bool isInAppPurchase;

  const PaymentOptionsModal({
    super.key,
    required this.onClose,
    required this.onPaymentSelected,
    this.isInAppPurchase = false,
  });

  final Map<String, Map<String, dynamic>> paymentOptions = const {
    'PayPal': {
      'icon': AppImageData.paypal,
    },
    'CashApp': {
      'icon': AppImageData.cashapp,
    },
    'Zelle': {
      'icon': AppImageData.zelle,
    },
  };

  Widget _buildTitle() {
    return Text(
      isInAppPurchase ? 'Fund from' : 'Pay Fees',
      style: AppTextStyle.poppins(
        fontSize: AppDimension.isSmall ? 24.sp : 20.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPaymentOption(String title) {
    final option = paymentOptions[title]!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onPaymentSelected(title);
          onClose();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimension.isSmall ? 10.h : 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: AppDimension.isSmall ? 58.w : 48.w,
                    height: AppDimension.isSmall ? 58.h : 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimension.isSmall ? 16.r : 12.r),
                      image: DecorationImage(
                        image: AssetImage(option['icon']),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimension.isSmall ? 20.w : 16.w),
                  Text(
                    title,
                    style: AppTextStyle.dmSans(
                      fontSize: AppDimension.isSmall ? 20.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              AppIcons(
                icon: AppIconData.arrowRight,
                color: Colors.black,
                size: AppDimension.isSmall ? 28.w : 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppModalContainer(
                width: double.infinity,
                height: AppDimension.isSmall ? 580.h : 300.h,
                fillColor: AppColors.purplePrimary,
                borderColor: AppColors.purpleLight,
                layerColor: AppColors.purpleDark,
                layerTopPosition: -4.h,
                borderRadius: AppDimension.isSmall ? 32.r : 24.r,
                title: '',
                customTitle: _buildTitle(),
                onClose: onClose,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(AppDimension.isSmall ? 24.r : 16.r),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppDimension.isSmall ? 20.r : 16.r),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(AppDimension.isSmall ? 24.r : 16.r),
                                    child: Column(
                                      children: paymentOptions.keys
                                          .map((title) => _buildPaymentOption(title))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
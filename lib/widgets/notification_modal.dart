import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'notification_card.dart';
import 'app_banner.dart';
import 'fund_withdrawal_modal.dart';

class NotificationModal extends StatelessWidget {
  final VoidCallback onClose;
  final List<Map<String, dynamic>> notifications;

  const NotificationModal({
    super.key,
    required this.onClose,
    required this.notifications,
  });

  void _handleClaimPrize(BuildContext context, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => FundWithdrawalModal(
        onClose: () {
          Navigator.of(context).pop();
        },
        amount: notification['amount'] ?? '130',
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
          child: Center(
            child: AppModalContainer(
              width: double.infinity,
              height: AppDimension.isSmall ? 900.h : 550.h,
              fillColor: AppColors.purplePrimary,
              borderColor: AppColors.purpleLight,
              layerColor: AppColors.purpleDark,
              layerTopPosition: -4.h,
              borderRadius: AppDimension.isSmall ? 32.r : 24.r,
              onClose: onClose,
              banner: AppBanner(
                text: 'Notification',
                fillColor: AppColors.yellowLight,
                borderColor: AppColors.yellowDark,
                textStyle: AppTextStyle.mochiyPopOne(
                  fontSize: AppDimension.isSmall ? 20.sp : 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                width: AppDimension.isSmall ? 200.w : 180.w,
                height: AppDimension.isSmall ? 45.h : 35.h,
                hasShadow: true,
                shadowColor: Colors.black,
                shadowBlurRadius: 15,
              ),
              child: Padding(
                padding: EdgeInsets.all(AppDimension.isSmall ? 14.r : 16.r),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimension.isSmall ? 20.r : 16.r),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.isSmall ? 14.w : 16.w,
                      vertical: AppDimension.isSmall ? 14.h : 16.h,
                    ),
                    child: Column(
                      children: notifications.map((notification) {
                        return NotificationCard(
                          title: notification['title'],
                          subtitle: notification['subtitle'],
                          buttonText: notification['buttonText'],
                          onButtonPressed: () => _handleClaimPrize(context, notification),
                          isRead: notification['isRead'] ?? false,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
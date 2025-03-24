import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.isRead = false,
  });

  Widget _buildGameNotification() {
    final lines = subtitle.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lines[0], // Game: Hip-Hop Fire Round
          style: AppTextStyle.dmSans(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(height: 2.h),
        Text(
          lines[1], // Game Code: 9823
          style: AppTextStyle.dmSans(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lines[2], // Starts in 10 minutes!
              style: AppTextStyle.dmSans(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            if (buttonText != null)
              SizedBox(
                height: 24.h,
                child: MaterialButton(
                  onPressed: isRead ? null : () {
                    onButtonPressed?.call();
                  },
                  color: isRead ? AppColors.grayDark : AppColors.purpleLight,
                  disabledColor: AppColors.grayDark,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    buttonText!,
                    style: AppTextStyle.dmSans(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegularNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: AppTextStyle.dmSans(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        if (buttonText != null) ...[
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 24.h,
              child: MaterialButton(
                onPressed: isRead ? null : () {
                  onButtonPressed?.call();
                },
                color: isRead ? AppColors.grayTransparent : AppColors.purpleLight,
                disabledColor: AppColors.grayTransparent,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  buttonText!,
                  style: AppTextStyle.dmSans(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGameNotification = subtitle.contains('Game:') && subtitle.contains('Game Code:');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isRead ? AppColors.grayLight : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isRead ? Colors.transparent : AppColors.purpleLight,
          width: 2.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyle.dmSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          isGameNotification ? _buildGameNotification() : _buildRegularNotification(),
        ],
      ),
    );
  }
} 
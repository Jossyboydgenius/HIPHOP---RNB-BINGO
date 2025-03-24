import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageCard extends StatelessWidget {
  final String message;
  final String senderName;
  final String senderInitials;
  final String time;
  final bool isMe;
  final VoidCallback? onProfileTap;

  const ChatMessageCard({
    super.key,
    required this.message,
    required this.senderName,
    required this.senderInitials,
    required this.time,
    this.isMe = false,
    this.onProfileTap,
  });

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (onProfileTap != null && !isMe) {
          _showProfileMenu(context, details.globalPosition);
        }
      },
      child: Stack(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
            ),
            child: Center(
              child: Text(
                senderInitials,
                style: AppTextStyle.poppins(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12.w,
              height: 12.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context, Offset position) {
    final items = [
      PopupMenuItem(
        height: 40.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImages(
              imagePath: AppImageData.ban,
              width: 16.w,
              height: 16.h,
            ),
            SizedBox(width: 8.w),
            Text(
              'Report',
              style: AppTextStyle.dmSans(
                fontSize: 11.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          // Handle report
        },
      ),
      PopupMenuItem(
        height: 40.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImages(
              imagePath: AppImageData.mute,
              width: 16.w,
              height: 16.h,
            ),
            SizedBox(width: 8.w),
            Text(
              'Mute',
              style: AppTextStyle.dmSans(
                fontSize: 11.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          // Handle mute
        },
      ),
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: items,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.grayDark),
      ),
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _buildAvatar(context),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isMe ? 'Me' : senderName,
                      style: AppTextStyle.dmSans(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyle.dmSans(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.purplePrimary,
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(isMe ? 16.r : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16.r),
                    ),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyle.dmSans(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8.w),
            _buildAvatar(context),
          ],
        ],
      ),
    );
  }
} 
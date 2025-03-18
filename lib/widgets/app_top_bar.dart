import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_images.dart';
import 'app_text_style.dart';

class AppTopBar extends StatelessWidget {
  final String initials;
  final String gemAmount;
  final String cardAmount;
  final int notificationCount;

  const AppTopBar({
    super.key,
    required this.initials,
    required this.gemAmount,
    required this.cardAmount,
    required this.notificationCount,
  });

  Widget _buildUserAvatar() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.teal,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountContainer({
    required Color color,
    required String amount,
    required String leftIcon,
    required String rightIcon,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Text(
            amount,
            style: AppTextStyle.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: -14,
          top: 0,
          bottom: 0,
          child: Center(
            child: AppIcons(
              icon: leftIcon,
              size: 34,
            ),
          ),
        ),
        Positioned(
          right: -8,
          top: 0,
          bottom: 0,
          child: Center(
            child: AppIcons(
              icon: rightIcon,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const AppImages(
          imagePath: AppImageData.notification,
          height: 32,
        ),
        if (notificationCount > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Text(
                notificationCount.toString(),
                style: AppTextStyle.poppins(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUserAvatar(),
          Row(
            children: [
              _buildAmountContainer(
                color: AppColors.purplePrimary,
                amount: gemAmount,
                leftIcon: AppIconData.gem,
                rightIcon: AppIconData.add,
              ),
              const SizedBox(width: 34),
              _buildAmountContainer(
                color: AppColors.yellowPrimary,
                amount: cardAmount,
                leftIcon: AppIconData.card,
                rightIcon: AppIconData.add2,
              ),
            ],
          ),
          _buildNotificationIcon(),
        ],
      ),
    );
  }
} 
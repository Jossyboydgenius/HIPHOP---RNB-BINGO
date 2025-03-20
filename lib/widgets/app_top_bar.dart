import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_images.dart';
import 'app_text_style.dart';
import 'notification_modal.dart';
import 'chat_room_modal.dart';

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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.teal,
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

  Widget _buildNotificationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationModal(
            onClose: () {
              Navigator.of(context).pop();
            },
            notifications: [
              {
                'title': 'Congratulations! You Won!',
                'subtitle': 'Your Bingo win has been confirmed! Click below to withdraw your prize: \$50',
                'buttonText': 'Claim Prize',
                'onButtonPressed': () {
                  // TODO: Handle claim prize
                },
                'isRead': false,
              },
              {
                'title': 'DJ Ray invited you to play!',
                'subtitle': 'Game: Hip-Hop Fire Round\nGame Code: 9823\nStarts in 10 minutes!',
                'buttonText': 'Join Game',
                'onButtonPressed': () {
                  // TODO: Handle join game
                },
                'isRead': false,
              },
              {
                'title': 'Congratulations! You Won!',
                'subtitle': 'Your Bingo win has been confirmed! Click below to withdraw your prize: \$10',
                'buttonText': 'Claim Prize',
                'onButtonPressed': () {
                  // TODO: Handle claim prize
                },
                'isRead': true,
              },
              const {
                'title': 'Purchase of \$20 Bingo Board',
                'subtitle': "You've successfully purchased a 5 Bingo Board for \$20",
                'isRead': true,
              },
            ],
          ),
        );
      },
      child: Stack(
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
      ),
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
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => ChatRoomModal(
                      onClose: () {
                        Navigator.of(context).pop();
                      },
                      userInitials: 'JD', // Replace with actual user initials
                      activeUsers: 2500,
                      isConnected: true,
                    ),
                  );
                },
                child: _buildAmountContainer(
                  color: AppColors.purplePrimary,
                  amount: gemAmount,
                  leftIcon: AppIconData.gem,
                  rightIcon: AppIconData.add,
                ),
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
          _buildNotificationIcon(context),
        ],
      ),
    );
  }
} 
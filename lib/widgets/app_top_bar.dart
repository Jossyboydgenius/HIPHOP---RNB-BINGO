import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_state.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_images.dart';
import 'app_text_style.dart';
import 'notification_modal.dart';
import 'user_profile_modal.dart';
import 'wallet_funding_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bingo_boards_store_modal.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';

class AppTopBar extends StatefulWidget {
  final String initials;
  final int notificationCount;

  const AppTopBar({
    super.key,
    required this.initials,
    required this.notificationCount,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  String? _selectedAvatar;
  bool _isMoneyExpanded = false;
  final _soundService = GameSoundService();

  Widget _buildUserAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Play sound and haptic feedback
        _soundService.playButtonClick();
        _showUserProfile(context);
      },
      child: Stack(
        children: [
          if (_selectedAvatar != null)
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AppImages(
                  imagePath: _selectedAvatar!,
                  width: 48.w,
                  height: 48.h,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 48.w,
              height: 48.h,
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
                  widget.initials,
                  style: AppTextStyle.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

  Widget _buildAmountContainer({
    required Color color,
    required String amount,
    required String leftIcon,
    String? rightIcon,
    bool isCollapsed = false,
    bool isIconImage = true,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: Colors.white,
              width: 2.w,
            ),
          ),
          child: Text(
            isCollapsed ? '..' : amount,
            style: AppTextStyle.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: -14.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: isIconImage
                ? AppImages(
                    imagePath: leftIcon,
                    width: 34.w,
                    height: 34.h,
                  )
                : AppIcons(
                    icon: leftIcon,
                    size: 34.w,
                  ),
          ),
        ),
        if (rightIcon != null)
          Positioned(
            right: -8.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: AppIcons(
                icon: rightIcon,
                size: 24.w,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Play sound and haptic feedback
        _soundService.playButtonClick();
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
                'subtitle':
                    'Your Bingo win has been confirmed! Click below to withdraw your prize: \$50',
                'buttonText': 'Claim Prize',
                'onButtonPressed': () {
                  // TODO: Handle claim prize
                },
                'isRead': false,
              },
              {
                'title': 'DJ Ray invited you to play!',
                'subtitle':
                    'Game: Hip-Hop Fire Round\nGame Code: 9823\nStarts in 10 minutes!',
                'buttonText': 'Join Game',
                'onButtonPressed': () {
                  // TODO: Handle join game
                },
                'isRead': false,
              },
              {
                'title': 'Congratulations! You Won!',
                'subtitle':
                    'Your Bingo win has been confirmed! Click below to withdraw your prize: \$10',
                'buttonText': 'Claim Prize',
                'onButtonPressed': () {
                  // TODO: Handle claim prize
                },
                'isRead': true,
              },
              const {
                'title': 'Purchase of \$20 Bingo Board',
                'subtitle':
                    "You've successfully purchased a 5 Bingo Board for \$20",
                'isRead': true,
              },
            ],
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppImages(
            imagePath: AppImageData.notification,
            height: 32.h,
          ),
          if (widget.notificationCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: EdgeInsets.all(6.h),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  widget.notificationCount.toString(),
                  style: AppTextStyle.poppins(
                    fontSize: 8.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => UserProfileModal(
        onClose: () {
          Navigator.of(context).pop();
        },
        userInitials: widget.initials,
        currentAvatar: _selectedAvatar,
        onAvatarChanged: (String? newAvatar) {
          setState(() {
            _selectedAvatar = newAvatar;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildUserAvatar(context),
              Row(
                children: [
                  // Money container (collapsible)
                  GestureDetector(
                    onTap: () {
                      // Play sound and haptic feedback
                      _soundService.playButtonClick();
                      setState(() {
                        _isMoneyExpanded = !_isMoneyExpanded;
                      });
                    },
                    child: _buildAmountContainer(
                      color: AppColors.green,
                      amount: state.moneyBalance.toString(),
                      leftIcon: AppImageData.money,
                      isCollapsed: !_isMoneyExpanded,
                      isIconImage: true,
                    ),
                  ),
                  SizedBox(width: 12.w), // Reduced spacing
                  // Gem container (also triggers money expansion on tap)
                  GestureDetector(
                    onTap: () {
                      // Play sound and haptic feedback
                      _soundService.playButtonClick();

                      // Toggle money expansion when clicking on gem
                      setState(() {
                        _isMoneyExpanded = !_isMoneyExpanded;
                      });

                      // Only show the funding modal if we're collapsing money
                      if (!_isMoneyExpanded) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => WalletFundingModal(
                            onClose: () => Navigator.of(context).pop(),
                          ),
                        );
                      }
                    },
                    child: _buildAmountContainer(
                      color: AppColors.purplePrimary,
                      amount: state.gemBalance.toString(),
                      leftIcon: AppIconData.gem,
                      rightIcon: AppIconData.add,
                      isCollapsed: _isMoneyExpanded,
                      isIconImage: false,
                    ),
                  ),
                  SizedBox(
                      width:
                          22.w), // Reduced spacing (shifted board to the left)
                  // Board container (never collapses)
                  GestureDetector(
                    onTap: () {
                      // Play sound and haptic feedback
                      _soundService.playButtonClick();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) =>
                            BingoBoardsStoreModal(
                          onClose: () => Navigator.of(context).pop(),
                        ),
                      );
                    },
                    child: _buildAmountContainer(
                      color: AppColors.yellowPrimary,
                      amount: state.boardBalance.toString(),
                      leftIcon: AppIconData.card,
                      rightIcon: AppIconData.add2,
                      isIconImage: false,
                    ),
                  ),
                ],
              ),
              _buildNotificationIcon(context),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_images.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: const Center(
            child: Text(
              'JD',
              style: TextStyle(
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
    double leftIconOffset = -12,
    double rightIconOffset = -12,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: leftIconOffset,
          top: 0,
          bottom: 0,
          child: Center(
            child: AppIcons(icon: leftIcon, size: 24),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          right: rightIconOffset,
          top: 0,
          bottom: 0,
          child: Center(
            child: AppIcons(icon: rightIcon, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        const AppImages(
          imagePath: AppImageData.notification,
          height: 32,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '1',
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
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildUserAvatar(),
                    Row(
                      children: [
                        _buildAmountContainer(
                          color: AppColors.purplePrimary,
                          amount: '1200',
                          leftIcon: AppIconData.gem,
                          rightIcon: AppIconData.add,
                          leftIconOffset: -12,
                          rightIconOffset: -12,
                        ),
                        const SizedBox(width: 24),
                        _buildAmountContainer(
                          color: AppColors.yellowPrimary,
                          amount: '120',
                          leftIcon: AppIconData.card1,
                          rightIcon: AppIconData.add2,
                          leftIconOffset: -12,
                          rightIconOffset: -12,
                        ),
                      ],
                    ),
                    _buildNotificationIcon(),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              const AppImages(
                imagePath: AppImageData.bingo,
                height: 200,
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    AppButton(
                      text: 'In-Person',
                      subtitle: 'Join by purchasing ticket',
                      fillColor: AppColors.yellowDark,
                      layerColor: AppColors.yellowPrimary,
                      height: 120,
                      hasBorder: true,
                      layerTopPosition: -2,
                      layerHeight: 100,
                      borderRadius: 32,
                      borderColor: Colors.white,
                      textColor: Colors.white,
                      fontFamily: AppTextStyle.mochiyPopOneFont,
                      fontSize: 24,
                      subtitleFontSize: 12,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Remote Online',
                      subtitle: 'Join live hosted event',
                      fillColor: AppColors.purpleDark,
                      layerColor: AppColors.purplePrimary,
                      height: 120,
                      hasBorder: true,
                      layerTopPosition: -2,
                      layerHeight: 100,
                      borderRadius: 32,
                      borderColor: Colors.white,
                      textColor: Colors.white,
                      fontFamily: AppTextStyle.mochiyPopOneFont,
                      fontSize: 24,
                      subtitleFontSize: 12,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 158),
            ],
          ),
        ),
      ),
    );
  }
} 
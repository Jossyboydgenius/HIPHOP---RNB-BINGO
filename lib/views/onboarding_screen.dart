import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_images.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_text_style.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                // Logo
                const AppImages(
                  imagePath: AppImageData.bingo,
                  height: 200,
                ),
                const Spacer(),
                // Buttons Container
                Container(
                  margin: const EdgeInsets.only(bottom: 168),
                  child: Column(
                    children: [
                      // Sign In Button
                      AppButton(
                        text: 'Sign In',
                        // subtitle: 'Welcome back!',
                        fillColor: AppColors.yellowDark,
                        layerColor: AppColors.yellowPrimary,
                        height: 72,
                        hasBorder: true,
                        layerTopPosition: -2, // Adjust this value to control the yellow overlay position
                        layerHeight: 60, // Adjust this value to control the yellow overlay height
                        fontFamily: AppTextStyle.poppinsFont,
                        fontSize: 24,
                        subtitleFontSize: 14,
                        onPressed: () {
                          // TODO: Navigate to sign in screen
                        },
                      ),
                      const SizedBox(height: 26),
                      // Sign Up Button
                      AppButton(
                        text: 'Sign Up',
                        // subtitle: 'Create an account',
                        fillColor: AppColors.purpleDark,
                        layerColor: AppColors.purplePrimary,
                        height: 72,
                        hasBorder: true,
                        layerTopPosition: -2, // Adjust this value to control the purple overlay position
                        layerHeight: 60, // Adjust this value to control the purple overlay height
                        fontFamily: AppTextStyle.poppinsFont,
                        fontSize: 24,
                        subtitleFontSize: 14,
                        onPressed: () {
                          // TODO: Navigate to sign up screen
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
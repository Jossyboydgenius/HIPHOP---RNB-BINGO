import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_images.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_modal_container.dart';
import '../widgets/app_icons.dart';
import '../enums/modal_type.dart';
import '../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  ModalType? _currentModal;
  bool _isModalVisible = false;

  void _showModal(ModalType type) {
    setState(() {
      _currentModal = type;
      _isModalVisible = true;
    });
  }

  void _hideModal() {
    setState(() {
      _isModalVisible = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _currentModal = null;
        });
      }
    });
  }

  Widget _buildModalContent(ModalType type) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AppButton(
                text: 'Google',
                iconPath: AppIconData.google,
                fillColor: AppColors.purpleOverlay,
                layerColor: Colors.white,
                height: 62,
                hasBorder: true,
                layerTopPosition: 0,
                layerHeight: 50,
                borderRadius: 100,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.dmSansFont,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Facebook',
                iconPath: AppIconData.facebook,
                fillColor: AppColors.purpleOverlay,
                layerColor: Colors.white,
                height: 62,
                hasBorder: true,
                layerTopPosition: 0,
                layerHeight: 50,
                borderRadius: 100,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.dmSansFont,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Apple',
                iconPath: AppIconData.apple,
                fillColor: AppColors.purpleOverlay,
                layerColor: Colors.white,
                height: 62,
                hasBorder: true,
                layerTopPosition: 0,
                layerHeight: 50,
                borderRadius: 100,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.dmSansFont,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 32,
            left: 24,
            right: 24,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle.dmSans(
                fontSize: 18,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
              children: [
                const TextSpan(
                  text: 'By continuing, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Services',
                  style: AppTextStyle.dmSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' & '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppTextStyle.dmSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.splash);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background and main content
            AppBackground(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Spacer(),
                      const AppImages(
                        imagePath: AppImageData.bingo,
                        height: 200,
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 168),
                        child: Column(
                          children: [
                            AppButton(
                              text: 'Sign In',
                              fillColor: AppColors.yellowDark,
                              layerColor: AppColors.yellowPrimary,
                              height: 72,
                              hasBorder: true,
                              layerTopPosition: -2,
                              layerHeight: 60,
                              fontFamily: AppTextStyle.poppinsFont,
                              fontSize: 24,
                              onPressed: () => _showModal(ModalType.signIn),
                            ),
                            const SizedBox(height: 26),
                            AppButton(
                              text: 'Sign Up',
                              fillColor: AppColors.purpleDark,
                              layerColor: AppColors.purplePrimary,
                              height: 72,
                              hasBorder: true,
                              layerTopPosition: -2,
                              layerHeight: 60,
                              fontFamily: AppTextStyle.poppinsFont,
                              fontSize: 24,
                              onPressed: () => _showModal(ModalType.signUp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Modal overlay with blur
            if (_currentModal != null)
              AnimatedOpacity(
                opacity: _isModalVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black54,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: AppModalContainer(
                          height: 420,
                          fillColor: _currentModal == ModalType.signIn 
                              ? AppColors.yellowPrimary 
                              : AppColors.purplePrimary,
                          borderColor: _currentModal == ModalType.signIn 
                              ? AppColors.yellowLight 
                              : AppColors.purpleLight,
                          layerColor: _currentModal == ModalType.signIn 
                              ? AppColors.yellowDark 
                              : AppColors.purpleDark,
                          layerTopPosition: -4,
                          borderRadius: 32,
                          title: _currentModal == ModalType.signIn ? 'Sign In' : 'Sign Up',
                          onClose: _hideModal,
                          child: _buildModalContent(_currentModal!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 
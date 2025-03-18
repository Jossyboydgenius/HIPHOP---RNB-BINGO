import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_images.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_modal_container.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Colors.transparent,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: AppModalContainer(
                        type: _currentModal!,
                        onClose: _hideModal,
                        onGooglePressed: () {
                          // TODO: Implement Google sign in/up
                        },
                        onFacebookPressed: () {
                          // TODO: Implement Facebook sign in/up
                        },
                        onApplePressed: () {
                          // TODO: Implement Apple sign in/up
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 
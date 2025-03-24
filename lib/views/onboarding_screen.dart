import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              AppButton(
                text: 'Google',
                iconPath: AppIconData.google,
                fillColor: AppColors.purpleOverlay,
                layerColor: Colors.white,
                height: 44.h,
                hasBorder: true,
                layerTopPosition: 0,
                layerHeight: 34.h,
                borderRadius: 100,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.dmSansFont,
                fontSize: 14.sp,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              SizedBox(height: 8.h),
              AppButton(
                text: 'Facebook',
                iconPath: AppIconData.facebook,
                fillColor: AppColors.purpleOverlay,
                layerColor: Colors.white,
                height: 44.h,
                hasBorder: true,
                layerTopPosition: 0,
                layerHeight: 34.h,
                borderRadius: 100,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.dmSansFont,
                fontSize: 14.sp,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              SizedBox(height: 8.h),
              AppButton(
                text: 'Apple',
                iconPath: AppIconData.apple,
                fillColor: AppColors.purpleOverlay,
                layerColor: Colors.white,
                height: 44.h,
                hasBorder: true,
                layerTopPosition: 0,
                layerHeight: 34.h,
                borderRadius: 100,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.dmSansFont,
                fontSize: 14.sp,
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
                fontSize: 12.sp,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
              children: [
                const TextSpan(
                  text: 'By continuing, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Services & Privacy Policy',
                  style: AppTextStyle.dmSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
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
            AppBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    AppImages(
                      imagePath: AppImageData.bingo,
                      height: 200.h,
                    ),
                    SizedBox(height: 60.h),
                    Container(
                      margin: EdgeInsets.only(bottom: 168.h),
                      child: Center(
                        child: Column(
                          children: [
                            AppButton(
                              text: 'Sign In',
                              textStyle: AppTextStyle.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                              fillColor: AppColors.yellowDark,
                              layerColor: AppColors.yellowPrimary,
                              height: 50.h,
                              width: 240.w,
                              hasBorder: true,
                              layerTopPosition: -2.h,
                              layerHeight: 40.h,
                              borderWidth: 3.w,
                              borderRadius: 18.r,
                              fontFamily: AppTextStyle.poppinsFont,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              onPressed: () => _showModal(ModalType.signIn),
                            ),
                            SizedBox(height: 22.h),
                            AppButton(
                              text: 'Sign Up',
                              textStyle: AppTextStyle.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                              fillColor: AppColors.purpleDark,
                              layerColor: AppColors.purplePrimary,
                              height: 50.h,
                              width: 240.w,
                              hasBorder: true,
                              layerTopPosition: -2.h,
                              layerHeight: 40.h,
                              borderWidth: 3.w,
                              borderRadius: 18.r,
                              fontFamily: AppTextStyle.poppinsFont,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              onPressed: () => _showModal(ModalType.signUp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            if (_currentModal != null)
              AnimatedOpacity(
                opacity: _isModalVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black54,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Center(
                        child: AppModalContainer(
                          height: 300.h,
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
                          titleStyle: AppTextStyle.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
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
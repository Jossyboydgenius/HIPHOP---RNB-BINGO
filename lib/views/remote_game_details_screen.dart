import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import '../routes/app_routes.dart';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/game_details_container.dart';
import '../widgets/payment_options_modal.dart';
import '../widgets/app_toast.dart';

class RemoteGameDetailsScreen extends StatefulWidget {
  final String? code;

  const RemoteGameDetailsScreen({
    super.key,
    this.code,
  });

  @override
  State<RemoteGameDetailsScreen> createState() => _RemoteGameDetailsScreenState();
}

class _RemoteGameDetailsScreenState extends State<RemoteGameDetailsScreen> {
  bool _isWaiting = false;
  bool _canStart = false;
  bool _hasPaid = false;
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isWaiting = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isWaiting = false;
          _canStart = true;
        }
      });
    });
  }

  void _showPaymentOptions() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PaymentOptionsModal(
        onClose: () {
          Navigator.of(context).pop(); // Just close the modal
        },
        onPaymentSelected: (paymentMethod) {
          // First close the payment modal
          Navigator.of(context).pop();
          
          // Then update the state to enable join game and start countdown
          setState(() {
            _hasPaid = true;
          });
          
          // Start the countdown immediately after payment
          _startCountdown();
        },
      ),
    );
  }

  String get _timeString {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return false;
      },
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                const AppTopBar(
                  initials: 'JD',
                  notificationCount: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 6.h,
                              child: AppImages(
                                imagePath: AppImageData.www,
                                width: 40.w,
                                height: 40.h,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 35.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.pinkDark,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Zoom Game Link',
                                    style: AppTextStyle.mochiyPopOne(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  AppIcons(
                                    icon: AppIconData.copy,
                                    size: 16.w,
                                    color: Colors.white,
                                    onPressed: () {
                                      Clipboard.setData(const ClipboardData(
                                        text: 'https://zoom.us/j/123456789',
                                      )).then((_) {
                                        AppToast.show(
                                          context,
                                          'Game link copied to clipboard',
                                          showInfoIcon: false,
                                          showCloseIcon: true,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: -10.h,
                              height: 60.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.purpleDark,
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: AppColors.purplePrimary,
                                  width: 3.w,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.r),
                                child: AppImages(
                                  imagePath: AppImageData.gameImage,
                                  width: 250.w,
                                  height: 250.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Lorem ipsum dolor sit amet',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.mochiyPopOne(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GameDetailsContainer(
                          host: 'John Doe',
                          dj: 'DJ Ray',
                          rounds: '3 rounds',
                          musicTheme: '90s R&B',
                          gameType: 'Classic',
                          gameFee: '5',
                          cardAmount: '3',
                          showMoneyIcon: true,
                          showCardIcon: true,
                          gameStyles: const [
                            'T-Shape',
                            'Blackout',
                            'X Pattern',
                            'Four Corners',
                            'Straight Line',
                          ],
                          timeRemaining: _timeString,
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: 200.w,
                          child: _canStart
                              ? AppButton(
                                  text: 'Start',
                                  textStyle: AppTextStyle.poppins(
                                    fontSize: AppDimension.isSmall ? 18.sp : 18.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  fillColor: AppColors.greenBright,
                                  layerColor: AppColors.greenDark,
                                  height: AppDimension.isSmall ? 70.h : 50.h,
                                  hasBorder: true,
                                  layerTopPosition: -2.h,
                                  layerHeight: AppDimension.isSmall ? 54.h : 42.h,
                                  fontFamily: AppTextStyle.poppinsFont,
                                  fontSize: AppDimension.isSmall ? 18.sp : 18.sp,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
                                  },
                                )
                              : AppButton(
                                  text: _isWaiting ? 'Waiting...' : 'Join Game',
                                  textStyle: AppTextStyle.poppins(
                                    fontSize: AppDimension.isSmall ? 18.sp : 18.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  fillColor: _isWaiting
                                      ? AppColors.yellowDark
                                      : AppColors.greenDark,
                                  layerColor: _isWaiting
                                      ? AppColors.yellowPrimary
                                      : AppColors.greenBright,
                                  height: AppDimension.isSmall ? 70.h : 50.h,
                                  hasBorder: true,
                                  layerTopPosition: -2.h,
                                  layerHeight: AppDimension.isSmall ? 54.h : 42.h,
                                  fontFamily: AppTextStyle.poppinsFont,
                                  fontSize: AppDimension.isSmall ? 18.sp : 18.sp,
                                  onPressed: _isWaiting
                                      ? null
                                      : () {
                                          if (!_hasPaid) {
                                            _showPaymentOptions();
                                          }
                                        },
                                ),
                        ),
                      ],
                    ),
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/routes/app_routes.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_background.dart';
import '../widgets/app_top_bar.dart';
import 'qr_code_scanner_screen.dart';
import 'input_code_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMode;

  Widget _buildInitialScreen() {
    return Column(
      children: [
        const AppTopBar(
          initials: 'JD',
          notificationCount: 1,
        ),
        const Spacer(flex: 2),
        AppImages(
          imagePath: AppImageData.bingo,
          height: AppDimension.isSmall ? 280.h : 180.h,
        ),
        const Spacer(flex: 1),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                text: 'In-Person',
                subtitle: 'Join by purchasing ticket',
                fillColor: AppColors.yellowDark,
                layerColor: AppColors.yellowPrimary,
                height: AppDimension.isSmall ? 120.h : 100.h,
                width: AppDimension.isSmall ? 280.w : 240.w,
                hasBorder: true,
                layerTopPosition: -3.h,
                layerHeight: AppDimension.isSmall ? 102.h : 88.h,
                borderRadius: AppDimension.isSmall ? 28.r : 24.r,
                borderColor: Colors.white,
                borderWidth: AppDimension.isSmall ? 5.w : 4.w,
                textColor: Colors.white,
                fontFamily: AppTextStyle.poppinsFont,
                fontWeight: FontWeight.w800,
                subtitleStyle: TextStyle(
                  fontFamily: AppTextStyle.mochiyPopOneFont,
                  fontSize: AppDimension.getFontSize(12).sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                fontSize: AppDimension.isSmall ? 24.sp : 22.sp,
                onPressed: () => setState(() => selectedMode = 'In-Person'),
              ),
              SizedBox(height: AppDimension.isSmall ? 32.h : 24.h),
              AppButton(
                text: 'Remote Online',
                subtitle: 'Join live hosted event',
                fillColor: AppColors.purpleDark,
                layerColor: AppColors.purplePrimary,
                height: AppDimension.isSmall ? 120.h : 100.h,
                width: AppDimension.isSmall ? 280.w : 240.w,
                hasBorder: true,
                layerTopPosition: -3.h,
                layerHeight: AppDimension.isSmall ? 102.h : 88.h,
                borderRadius: AppDimension.isSmall ? 28.r : 24.r,
                borderColor: Colors.white,
                borderWidth: AppDimension.isSmall ? 5.w : 4.w,
                textColor: Colors.white,
                fontFamily: AppTextStyle.poppinsFont,
                fontWeight: FontWeight.w800,
                subtitleStyle: TextStyle(
                  fontFamily: AppTextStyle.mochiyPopOneFont,
                  fontSize: AppDimension.getFontSize(12).sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                fontSize: AppDimension.isSmall ? 24.sp : 22.sp,
                onPressed: () => setState(() => selectedMode = 'Remote Online'),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimension.isSmall ? 120.h : 158.h),
      ],
    );
  }

  Widget _buildJoinGameScreen() {
    final isInPerson = selectedMode == 'In-Person';
    
    return Column(
      children: [
        // Header with back button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: AppDimension.isSmall ? 24.h : 16.h),
          child: Row(
            children: [
              AppImages(
                imagePath: AppImageData.back,
                height: AppDimension.isSmall ? 38.h : 38.h,
                width: AppDimension.isSmall ? 38.w : 38.w,
                onPressed: () => setState(() => selectedMode = null),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Join Game',
                    style: AppTextStyle.mochiyPopOne(
                      fontSize: AppDimension.isSmall ? 22.sp : 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimension.isSmall ? 48.w : 24.w),
            ],
          ),
        ),
        SizedBox(height: AppDimension.isSmall ? 140.h : 100.h),
        // Mode Button
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                text: selectedMode!,
                subtitle: isInPerson ? 'Join by purchasing ticket' : 'Join live hosted event',
                fillColor: isInPerson ? AppColors.yellowDark : AppColors.purpleDark,
                layerColor: isInPerson ? AppColors.yellowPrimary : AppColors.purplePrimary,
                height: AppDimension.isSmall ? 120.h : 100.h,
                width: AppDimension.isSmall ? 280.w : 240.w,
                hasBorder: true,
                layerTopPosition: -3.h,
                layerHeight: AppDimension.isSmall ? 102.h : 88.h,
                borderRadius: AppDimension.isSmall ? 28.r : 24.r,
                borderColor: Colors.white,
                borderWidth: AppDimension.isSmall ? 5.w : 4.w,
                textColor: Colors.white,
                fontFamily: AppTextStyle.poppinsFont,
                fontWeight: FontWeight.w800,
                subtitleStyle: TextStyle(
                  fontFamily: AppTextStyle.mochiyPopOneFont,
                  fontSize: AppDimension.getFontSize(12).sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                fontSize: AppDimension.isSmall ? 24.sp : 22.sp,
                onPressed: null,
              ),
              SizedBox(height: AppDimension.isSmall ? 80.h : 60.h),
              Text(
                'To Join Game',
                style: AppTextStyle.mochiyPopOne(
                  fontSize: AppDimension.getFontSize(14).sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: AppDimension.isSmall ? 32.h : 24.h),
              AppButton(
                text: 'Scan QR',
                fillColor: AppColors.purpleDark,
                layerColor: AppColors.purplePrimary,
                height: AppDimension.isSmall ? 70.h : 56.h,
                width: AppDimension.isSmall ? 280.w : 240.w,
                hasBorder: true,
                layerTopPosition: -2.h,
                layerHeight: AppDimension.isSmall ? 54.h : 48.h,
                borderRadius: AppDimension.isSmall ? 26.r : 22.r,
                borderColor: Colors.white,
                borderWidth: AppDimension.isSmall ? 4.w : 3.w,
                textColor: Colors.white,
                fontFamily: AppTextStyle.mochiyPopOneFont,
                fontSize: AppDimension.getFontSize(12).sp,
                iconPath: AppIconData.scan,
                iconSize: AppDimension.isSmall ? 24.w : 24.w,
                iconSpacing: AppDimension.isSmall ? 12.w : 8.w,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRCodeScannerScreen(
                        isInPerson: isInPerson,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppDimension.isSmall ? 32.h : 26.h),
              AppButton(
                text: 'Input Code',
                fillColor: AppColors.purpleDark,
                layerColor: AppColors.purplePrimary,
                height: AppDimension.isSmall ? 70.h : 56.h,
                width: AppDimension.isSmall ? 280.w : 240.w,
                hasBorder: true,
                layerTopPosition: -2.h,
                layerHeight: AppDimension.isSmall ? 54.h : 48.h,
                borderRadius: AppDimension.isSmall ? 26.r : 22.r,
                borderColor: Colors.white,
                borderWidth: AppDimension.isSmall ? 4.w : 3.w,
                textColor: Colors.white,
                fontFamily: AppTextStyle.mochiyPopOneFont,
                fontSize: AppDimension.getFontSize(12).sp,
                iconPath: AppIconData.password,
                iconSize: AppDimension.isSmall ? 24.w : 24.w,
                iconSpacing: AppDimension.isSmall ? 12.w : 8.w,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputCodeScreen(
                        isInPerson: isInPerson,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedMode != null) {
          setState(() => selectedMode = null);
          return false;
        }
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        return false;
      },
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: selectedMode == null
                ? _buildInitialScreen()
                : _buildJoinGameScreen(),
          ),
        ),
      ),
    );
  }
} 
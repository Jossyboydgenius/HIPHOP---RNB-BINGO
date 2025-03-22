import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/routes/app_routes.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
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
        const AppImages(
          imagePath: AppImageData.bingo,
          height: 200,
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
                height: 120,
                width: 280,
                hasBorder: true,
                layerTopPosition: -2,
                layerHeight: 102,
                borderRadius: 32,
                borderColor: Colors.white,
                borderWidth: 5,
                textColor: Colors.white,
                fontFamily: AppTextStyle.poppinsFont,
                fontWeight: FontWeight.w800,
                subtitleStyle: const TextStyle(
                  fontFamily: AppTextStyle.mochiyPopOneFont,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                fontSize: 24,
                onPressed: () => setState(() => selectedMode = 'In-Person'),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Remote Online',
                subtitle: 'Join live hosted event',
                fillColor: AppColors.purpleDark,
                layerColor: AppColors.purplePrimary,
                height: 120,
                width: 280,
                hasBorder: true,
                layerTopPosition: -2,
                layerHeight: 102,
                borderRadius: 32,
                borderColor: Colors.white,
                borderWidth: 5,
                textColor: Colors.white,
                fontFamily: AppTextStyle.poppinsFont,
                fontWeight: FontWeight.w800,
                subtitleStyle: const TextStyle(
                  fontFamily: AppTextStyle.mochiyPopOneFont,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                fontSize: 24,
                onPressed: () => setState(() => selectedMode = 'Remote Online'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 158),
      ],
    );
  }

  Widget _buildJoinGameScreen() {
    final isInPerson = selectedMode == 'In-Person';
    
    return Column(
      children: [
        // Header with back button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              AppImages(
                imagePath: AppImageData.back,
                height: 38,
                width: 38,
                onPressed: () => setState(() => selectedMode = null),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Join Game',
                    style: AppTextStyle.mochiyPopOne(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
        const SizedBox(height: 140),
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
                height: 120,
                width: 280,
                hasBorder: true,
                layerTopPosition: -2,
                layerHeight: 102,
                borderRadius: 32,
                borderColor: Colors.white,
                borderWidth: 5,
                textColor: Colors.white,
                fontFamily: AppTextStyle.poppinsFont,
                fontWeight: FontWeight.w800,
                subtitleStyle: const TextStyle(
                  fontFamily: AppTextStyle.mochiyPopOneFont,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.white,
                ),
                fontSize: 24,
                onPressed: null,
              ),
              const SizedBox(height: 64),
              Text(
                'To Join Game',
                style: AppTextStyle.mochiyPopOne(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Scan QR',
                fillColor: AppColors.purplePrimary,
                layerColor: AppColors.purpleDark,
                height: 56,
                width: 280,
                hasBorder: true,
                layerTopPosition: -2,
                layerHeight: 44,
                borderRadius: 16,
                borderColor: Colors.white,
                borderWidth: 5,
                textColor: Colors.white,
                fontFamily: AppTextStyle.mochiyPopOneFont,
                fontSize: 14,
                iconPath: AppIconData.scan,
                iconSize: 24,
                iconSpacing: 8,
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
              const SizedBox(height: 26),
              AppButton(
                text: 'Input Code',
                fillColor: AppColors.purplePrimary,
                layerColor: AppColors.purpleDark,
                height: 56,
                width: 280,
                hasBorder: true,
                layerTopPosition: -2,
                layerHeight: 44,
                borderRadius: 16,
                borderColor: Colors.white,
                borderWidth: 5,
                textColor: Colors.white,
                fontFamily: AppTextStyle.mochiyPopOneFont,
                fontSize: 14,
                iconPath: AppIconData.password,
                iconSize: 24,
                iconSpacing: 8,
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
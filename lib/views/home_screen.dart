import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/routes/app_routes.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_background.dart';
import '../widgets/app_top_bar.dart';
import 'qr_code_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        return false;
      },
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                const AppTopBar(
                  initials: 'JD',
                  gemAmount: '1200',
                  cardAmount: '120',
                  notificationCount: 1,
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
                        borderWidth: 5,
                        textColor: Colors.white,
                        fontFamily: AppTextStyle.poppinsFont,
                        subtitleStyle: const TextStyle(
                          fontFamily: AppTextStyle.mochiyPopOneFont,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        fontSize: 24,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRCodeScannerScreen(),
                            ),
                          );
                        },
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
                        borderWidth: 5,
                        textColor: Colors.white,
                        fontFamily: AppTextStyle.poppinsFont,
                        subtitleStyle: const TextStyle(
                          fontFamily: AppTextStyle.mochiyPopOneFont,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        fontSize: 24,
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
      ),
    );
  }
} 
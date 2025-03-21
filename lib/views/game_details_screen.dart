import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/routes/app_routes.dart';
import 'dart:async';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/game_details_container.dart';

class GameDetailsScreen extends StatefulWidget {
  final String? code;

  const GameDetailsScreen({
    super.key,
    this.code,
  });

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  bool _isWaiting = false;
  bool _canStart = false;
  int _remainingSeconds = 60; // 1 minute countdown
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            const Positioned(
                              top: 5,
                              child: AppImages(
                                imagePath: AppImageData.map,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 35),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.pinkDark,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Game Location (City + Venue Name)',
                                style: AppTextStyle.mochiyPopOne(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: -10,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.purpleDark,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            Container(
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppColors.purplePrimary,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: const AppImages(
                                  imagePath: AppImageData.gameImage,
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Game Name Lorem ipsum dolor sit amet',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.mochiyPopOne(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GameDetailsContainer(
                          host: 'John Doe',
                          dj: 'DJ Ray',
                          rounds: '3 rounds',
                          musicTheme: '90s R&B',
                          gameType: 'Classic',
                          gameStyles: const [
                            'T-Shape',
                            'Blackout',
                            'X Pattern',
                            'Four Corners',
                            'Straight Line',
                          ],
                          timeRemaining: _timeString,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 200,
                          child: _canStart
                              ? AppButton(
                                  text: 'Start',
                                  fillColor: AppColors.greenDark,
                                  layerColor: AppColors.greenBright,
                                  height: 72,
                                  hasBorder: true,
                                  layerTopPosition: -2,
                                  layerHeight: 60,
                                  fontFamily: AppTextStyle.poppinsFont,
                                  fontSize: 24,
                                  onPressed: () {
                                    // Handle start game
                                  },
                                )
                              : AppButton(
                                  text: _isWaiting ? 'Waiting...' : 'Join Game',
                                  fillColor: _isWaiting
                                      ? AppColors.yellowDark
                                      : AppColors.greenDark,
                                  layerColor: _isWaiting
                                      ? AppColors.yellowPrimary
                                      : AppColors.greenBright,
                                  height: 72,
                                  hasBorder: true,
                                  layerTopPosition: -2,
                                  layerHeight: 60,
                                  fontFamily: AppTextStyle.poppinsFont,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  onPressed: _isWaiting ? null : _startCountdown,
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
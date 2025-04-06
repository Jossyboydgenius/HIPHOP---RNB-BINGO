import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import '../widgets/app_images.dart';
import '../widgets/app_loading_bar.dart';
import '../widgets/app_text_style.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../services/game_sound_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _loadingAnimation;
  final _soundService = GameSoundService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Play app launch sound when splash screen appears
    _playAppLaunchSound();

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        NavigationService.pushReplacementNamed(AppRoutes.onboarding);
      });
    });
  }

  Future<void> _playAppLaunchSound() async {
    await _soundService.playSound('assets/sounds/App-launch.mp3');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImages(
                imagePath: AppImageData.bingo,
                height: 280.h,
                animation: _scaleAnimation,
              ),
              SizedBox(height: 80.h),
              Text(
                'Loading....',
                style: AppTextStyle.dmSans(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  return AppLoadingBar(
                    progress: _loadingAnimation.value,
                    width: 140.w,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

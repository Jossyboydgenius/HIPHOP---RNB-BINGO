import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'dart:async';

class PatternChangeNotification extends StatefulWidget {
  final Map<String, Map<String, dynamic>> winningPatterns;

  const PatternChangeNotification({
    Key? key,
    required this.winningPatterns,
  }) : super(key: key);

  @override
  State<PatternChangeNotification> createState() =>
      _PatternChangeNotificationState();
}

class _PatternChangeNotificationState extends State<PatternChangeNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _patternChangeController;
  late Animation<double> _patternChangeAnimation;
  String _lastPattern = '';
  Timer? _hideTimer;
  final _soundService = GameSoundService();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for pattern changes
    _patternChangeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _patternChangeAnimation = CurvedAnimation(
      parent: _patternChangeController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _patternChangeController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  // Trigger animation when pattern changes
  void _animatePatternChange(String newPattern) {
    if (_lastPattern != newPattern) {
      _lastPattern = newPattern;
      _patternChangeController.reset();
      _patternChangeController.forward();

      // Play alert sound for new pattern
      _soundService.playAlertPopup();

      // Auto-hide after 5 seconds instead of 3
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          _patternChangeController.reverse();
        }
      });
    }
  }

  void _dismissPatternChange() {
    _hideTimer?.cancel();
    // Play button click sound when dismissing
    _soundService.playButtonClick();
    _patternChangeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BingoGameBloc, BingoGameState>(
      buildWhen: (previous, current) =>
          previous.winningPattern != current.winningPattern,
      builder: (context, state) {
        // Trigger animation when pattern changes
        _animatePatternChange(state.winningPattern);

        return AnimatedBuilder(
          animation: _patternChangeAnimation,
          builder: (context, child) {
            // Ensure opacity is always between 0.0 and 1.0
            final opacity = _patternChangeAnimation.value.clamp(0.0, 1.0);

            return Visibility(
              visible: opacity > 0,
              child: Stack(
                children: [
                  // Full screen tap detector
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _dismissPatternChange,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),

                  // Pattern notification
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: 1.0 + (1 - opacity) * 0.2,
                          child: GestureDetector(
                            onTap: _dismissPatternChange,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.purplePrimary,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'New Pattern',
                                    style: AppTextStyle.mochiyPopOne(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  AppImages(
                                    imagePath: widget.winningPatterns[state
                                        .winningPattern]!['image'] as String,
                                    width: 60.w,
                                    height: 60.h,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    widget.winningPatterns[state
                                        .winningPattern]!['title'] as String,
                                    style: AppTextStyle.mochiyPopOne(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

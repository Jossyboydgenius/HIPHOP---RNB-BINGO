import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/widgets/leaderboard/lose_leaderboard_modal.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoseModal extends StatefulWidget {
  final int round;
  final int countdownSeconds;
  final bool isFinalRound;
  final int totalRounds;
  final String winnerName;
  final VoidCallback? onClaimPrize;
  final VoidCallback? onContinue;
  final VoidCallback? onBackToHome;

  const LoseModal({
    super.key,
    required this.round,
    this.countdownSeconds = 60,
    this.isFinalRound = false,
    this.totalRounds = 3,
    this.winnerName = 'AI Player',
    this.onClaimPrize,
    this.onContinue,
    this.onBackToHome,
  });

  @override
  State<LoseModal> createState() => _LoseModalState();
}

class _LoseModalState extends State<LoseModal> {
  late Timer _timer;
  late int _secondsLeft;
  final _soundService = GameSoundService();
  List<PlayerScore> _winners = [];

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.countdownSeconds;
    _startTimer();
    _generateWinners();
  }

  void _generateWinners() {
    // Always ensure the specified winner name is included
    final Random random = Random();
    final List<PlayerScore> winners = [];

    // Add the main winner for this round
    winners.add(PlayerScore(
      name: widget.winnerName,
      round: widget.round,
      amount: (random.nextInt(7) + 3) * 10.0, // Random amount between $30-$100
      isCurrentPlayer: false,
    ));

    setState(() {
      _winners = winners;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer.cancel();
        _proceedToNextStep();
      }
    });
  }

  void _proceedToNextStep() {
    _timer.cancel();

    // First close this modal
    Navigator.of(context).pop();

    // Then either show leaderboard or continue to next round
    if (widget.isFinalRound) {
      _showLoseLeaderboard();
    } else {
      // Call the onContinue callback provided by GameScreen
      if (widget.onContinue != null) {
        widget.onContinue!();
      }
    }
  }

  void _continueToNextRound() {
    // This method is no longer needed as the logic is handled in _proceedToNextStep
    // However, we'll keep it for backward compatibility
    _proceedToNextStep();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showLoseLeaderboard() {
    // Close all existing modals first
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Show the leaderboard dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoseLeaderboardModal(
        onBackToHome: () {
          // Reset the game and go back home
          context.read<BingoGameBloc>().add(const ResetGame(isGameOver: true));
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
        },
      ),
    );
  }

  Widget _buildWinnerItem(PlayerScore player) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight2,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Round indicator
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ROUND',
                  style: AppTextStyle.poppins(
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  player.round.toString(),
                  style: AppTextStyle.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Player name
          Expanded(
            child: Text(
              player.name,
              style: AppTextStyle.mochiyPopOne(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            AppModalContainer(
              width: 340.w,
              height: 400.h,
              fillColor: Colors.white,
              borderColor: Colors.white,
              layerColor: AppColors.purpleOverlay,
              showCloseButton: false,
              handleBackNavigation: true,
              onClose: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 70.h),

                    // Winners title
                    Text(
                      'Winners',
                      style: AppTextStyle.mochiyPopOne(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),

                    // Winner list in scrollable container
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _winners
                              .map((winner) => _buildWinnerItem(winner))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Continue button with updated styling
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Continue',
                        textStyle: AppTextStyle.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        fillColor: AppColors.darkPurple,
                        layerColor: AppColors.darkPurple2,
                        extraLayerColor: AppColors.purpleOverlay,
                        extraLayerHeight: AppDimension.isSmall ? 70.h : 50.h,
                        extraLayerTopPosition: 4.h,
                        extraLayerOffset: 1,
                        height: AppDimension.isSmall ? 70.h : 50.h,
                        layerHeight: AppDimension.isSmall ? 57.h : 44.h,
                        layerTopPosition: -1.5.h,
                        hasBorder: true,
                        borderColor: Colors.white,
                        borderRadius: 24.r,
                        onPressed: () {
                          _soundService.playButtonClick();
                          _proceedToNextStep();
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Countdown text with improved formatting
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.isFinalRound
                                ? 'Proceed to Leaderboard in '
                                : 'Proceed to Round ${widget.round + 1} in ',
                            style: AppTextStyle.mochiyPopOne(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '$_secondsLeft Secs',
                            style: AppTextStyle.mochiyPopOne(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkPurple,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // "YOU LOSE" banner positioned above the modal
            Positioned(
              top: -95.h,
              child: AppImages(
                imagePath: AppImageData.lose,
                width: 340.w,
                height: 140.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';

class GameTimeContainer extends StatefulWidget {
  final int initialRound;
  final int maxRounds;
  final int timePerRoundInSeconds;
  final Function(bool didWin, int currentRound)? onRoundComplete;
  final VoidCallback? onTimeExpired;

  const GameTimeContainer({
    super.key,
    this.initialRound = 1,
    this.maxRounds = 3,
    this.timePerRoundInSeconds = 240, // 4 minutes per round
    this.onRoundComplete,
    this.onTimeExpired,
  });

  @override
  State<GameTimeContainer> createState() => _GameTimeContainerState();
}

class _GameTimeContainerState extends State<GameTimeContainer> {
  late int _currentRound;
  late int _secondsRemaining;
  Timer? _timer;
  bool _isTimerRunning = false;
  bool _isLoading = false; // New state to track loading spinner between rounds
  Timer? _loadingTimer; // Timer for loading screen
  final _soundService = GameSoundService(); // Add sound service instance

  // Getter to expose current round to parent
  int get currentRound => _currentRound;

  @override
  void initState() {
    super.initState();
    _currentRound = widget.initialRound;
    _secondsRemaining = widget.timePerRoundInSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _loadingTimer?.cancel();
    super.dispose();
  }

  // Public method to reset the timer
  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentRound = widget.initialRound;
      _secondsRemaining = widget.timePerRoundInSeconds;
      _isTimerRunning = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        // Time's up for this round, user loses
        _timer?.cancel();
        _isTimerRunning = false;

        // Only notify if at least one round was played
        if (_currentRound > 0) {
          // Notify the parent about time expiration, if callback is provided
          // Otherwise, fall back to onRoundComplete
          if (widget.onTimeExpired != null) {
            widget.onTimeExpired!();
          } else {
            widget.onRoundComplete?.call(false, _currentRound);
          }
          _showTimeUpMessage();
        }
      }
    });
  }

  void _showTimeUpMessage() {
    // Play wrong bingo sound
    _soundService.playWrongBingo();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            "Time's up! You didn't get Bingo in time.",
            style: AppTextStyle.mochiyPopOne(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _checkForWin(BingoGameState state) {
    if (state.hasWon && _isTimerRunning) {
      // User won this round, advance to next round if not at max rounds
      _timer?.cancel();
      _isTimerRunning = false;

      // Play correct bingo sound
      _soundService.playCorrectBingo();

      // No longer show loading spinner - just handle round advancement
      if (_currentRound < widget.maxRounds) {
        // After a delay, advance to next round
        _loadingTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            if (_currentRound < widget.maxRounds) {
              // Move to next round
              _currentRound++;
              _secondsRemaining = widget.timePerRoundInSeconds;

              // Play new round sound
              _soundService.playNewRound();

              // Reset the game state (keep the winning pattern)
              context.read<BingoGameBloc>().add(const ResetGame());

              // Start the timer for next round
              _startTimer();
            } else {
              // Player completed all rounds
              // Play prize win sound
              _soundService.playPrizeWin();

              widget.onRoundComplete?.call(true, _currentRound);
            }
          }
        });
      } else {
        // Player completed all rounds
        // Play prize win sound
        _soundService.playPrizeWin();

        widget.onRoundComplete?.call(true, _currentRound);
      }
    }
  }

  void _showRoundSuccessMessage() {
    // No longer needed - removing this message
  }

  void _showGameCompleteMessage() {
    // No longer needed - removing this message
  }

  String get _timeString {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Only check for win after user has claimed bingo
        BlocListener<BingoGameBloc, BingoGameState>(
          listenWhen: (previous, current) =>
              previous.hasWon != current.hasWon && current.hasWon,
          listener: (context, state) {
            _checkForWin(state);
          },
        ),
        BlocListener<BingoGameBloc, BingoGameState>(
          listenWhen: (_, __) => true, // Listen to all events
          listener: (context, _) {
            final BingoGameBloc bloc = context.read<BingoGameBloc>();
            if (bloc.hasResetFromGameOver) {
              // Reset the timer
              _timer?.cancel();
              setState(() {
                _currentRound = widget.initialRound;
                _secondsRemaining = widget.timePerRoundInSeconds;
                _isTimerRunning = false;
                _isLoading = false;
              });
              _startTimer();

              // Reset the flag
              bloc.resetGameOverFlag();
            }
          },
        ),
      ],
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimension.isSmall ? 6.w : 4.w,
              vertical: AppDimension.isSmall ? 6.h : 4.h,
            ),
            decoration: BoxDecoration(
              color:
                  _secondsRemaining < 10 ? AppColors.pinkDark : AppColors.teal,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: Colors.white,
                width: AppDimension.isSmall ? 2.w : 1.5.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: AppDimension.isSmall ? 14.w : 16.w),
                Text(
                  '$_timeString ($_currentRound)',
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: AppDimension.isSmall ? 10.sp : 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppDimension.isSmall ? -12.w : -10.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: AppImages(
                imagePath: AppImageData.time,
                width: AppDimension.isSmall ? 32.w : 28.w,
                height: AppDimension.isSmall ? 32.h : 28.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

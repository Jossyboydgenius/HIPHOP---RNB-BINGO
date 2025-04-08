import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hiphop_rnb_bingo/widgets/app_background.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';
import 'package:hiphop_rnb_bingo/widgets/game_time_container.dart';
import 'package:hiphop_rnb_bingo/widgets/game_player_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_board_box_container.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/chat_room_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/eliminated_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/victory_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/widgets/lose_modal.dart';
import 'dart:math';
import 'package:hiphop_rnb_bingo/views/home_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _patternChangeController;
  late Animation<double> _patternChangeAnimation;
  String _lastPattern = '';
  Timer? _hideTimer;
  // Number of rounds in the game
  final int _maxRounds = 3;
  // Time per round in seconds
  final int _timePerRound = 240; // 4 minutes
  // Current round tracker
  int _currentRound = 1;
  // Track player losses
  int _playerLosses = 0;
  // Force recreate timer
  int _timerKey = 0;

  // SuperTooltip controller
  final _tooltipController = SuperTooltipController();

  // Add sound service as a class member in _GameScreenState
  final _soundService = GameSoundService();

  Map<String, Map<String, dynamic>> get _winningPatterns => {
        'fourCornersBingo': {
          'image': AppImageData.fourCornersBingo,
          'title': 'Four Corners',
          'description': 'Mark all four corners of the board to win.',
        },
        'blackoutBingo': {
          'image': AppImageData.blackoutBingo,
          'title': 'Blackout',
          'description': 'Mark every square on the board to win.',
        },
        'straightlineBingo': {
          'image': AppImageData.straightlineBingo,
          'title': 'Straight Line',
          'description':
              'Mark 5 squares in a straight line (horizontal, vertical, or diagonal) to win.',
        },
        'tShapeBingo': {
          'image': AppImageData.tShapeBingo,
          'title': 'T-Shape',
          'description': 'Mark squares in a T-shape pattern to win.',
        },
        'xPatternBingo': {
          'image': AppImageData.xPatternBingo,
          'title': 'X-Pattern',
          'description': 'Mark squares in an X-pattern to win.',
        },
      };

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
    _tooltipController.dispose();
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

  // Method to handle round completion
  void _onRoundComplete(bool didWin, int currentRound) {
    if (didWin) {
      // Update our current round to match
      _currentRound = currentRound;

      if (currentRound >= _maxRounds) {
        // Game complete - user won all rounds
        _showFinalWinMessage();
      }
    } else if (!didWin) {
      // User lost the round
      _playerLosses++;

      if (_playerLosses >= 2) {
        // Player has lost twice, show eliminated modal
        _showFinalLoseMessage();
      } else {
        // Player still has another chance, show lose modal
        _showLoseModal(false);
      }
    }
  }

  void _showFinalWinMessage() {
    // Play prize win sound
    _soundService.playPrizeWin();

    // Reset player losses on win
    _playerLosses = 0;

    // Calculate the total prize amount for all rounds
    int grandTotalPrize = 0;
    for (int i = 1; i <= _maxRounds; i++) {
      grandTotalPrize += 50 * i;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: VictoryModal(
          roundNumber: _maxRounds,
          prizeAmount: grandTotalPrize,
          nextRoundSeconds: 60,
          isFinalRound: true,
          totalRounds: _maxRounds,
          onClaimPrize: () {
            // Navigator.pop is already handled in the modal
            // Reset game for a potential next play
            setState(() {
              _currentRound = 1; // Reset to first round
              _timerKey++; // Force timer recreation
            });

            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: true));
          },
        ),
      ),
    );
  }

  void _showFinalLoseMessage() {
    // Play wrong bingo sound
    _soundService.playWrongBingo();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: EliminatedModal(
          onTryAgain: () {
            // Only reset the game, Navigator.pop is already handled in the modal
            _playerLosses = 0; // Reset losses

            // Force timer recreation when trying again
            setState(() {
              _currentRound = 1; // Reset to first round
              _timerKey++; // Increment timer key to force recreation
            });

            context.read<BingoGameBloc>().add(ResetGame(isGameOver: true));
          },
        ),
      ),
    );
  }

  void _showWinningPatternDetails() {
    // Play button click sound
    _soundService.playButtonClick();

    final currentPattern = context.read<BingoGameBloc>().state.winningPattern;
    final pattern = _winningPatterns[currentPattern]!;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppColors.purplePrimary,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.purpleLight,
                width: 3.w,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current Winning Pattern',
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                // Pattern image
                AppImages(
                  imagePath: pattern['image'] as String,
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(height: 16.h),
                // Pattern title
                Text(
                  pattern['title'] as String,
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                // Pattern description
                Text(
                  pattern['description'] as String,
                  style: AppTextStyle.dmSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                // Pattern selector
                SizedBox(
                  height: 60.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _winningPatterns.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final patternKey = _winningPatterns.keys.elementAt(index);
                      final patternData = _winningPatterns[patternKey]!;
                      final isSelected = patternKey == currentPattern;

                      return GestureDetector(
                        onTap: () {
                          // Play board tap sound with haptic feedback
                          _soundService.playBoardTap();

                          // Update winning pattern
                          context.read<BingoGameBloc>().add(
                              CheckForWinningPattern(patternType: patternKey));
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.yellowPrimary
                                : AppColors.purplePrimary,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.w,
                            ),
                          ),
                          child: Center(
                            child: AppImages(
                              imagePath: patternData['image'] as String,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                // Close button
                GestureDetector(
                  onTap: () {
                    // Play board tap sound with haptic feedback
                    _soundService.playBoardTap();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.yellowPrimary,
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.w,
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: AppTextStyle.mochiyPopOne(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
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

  void _dismissPatternChange() {
    _hideTimer?.cancel();
    // Play button click sound when dismissing
    _soundService.playButtonClick();
    _patternChangeController.reverse();
    print("Pattern dismiss called!");
  }

  // Method to handle back button when tooltip is visible
  Future<bool> _willPopCallback() async {
    if (_tooltipController.isVisible) {
      await _tooltipController.hideTooltip();
      return false;
    }
    return true;
  }

  // void _handleFullScreenTap() {
  //   print(
  //       "Full screen tap detected! Animation value: ${_patternChangeAnimation.value}");
  //   if (_patternChangeAnimation.isCompleted) {
  //     print("Pattern notification is fully visible, dismissing");
  //     _dismissPatternChange();
  //   }
  // }

  // Method to show the victory modal for each completed round
  void _showRoundVictoryModal(BuildContext context, BingoGameState state) {
    // Use the current round from the class member
    int currentRound = _currentRound;

    // Reset player losses on round win
    _playerLosses = 0;

    // Check if this is the final round
    bool isFinalRound = currentRound >= _maxRounds;

    // Calculate prize amount - increase with rounds
    int prizeAmount = 50 * currentRound;

    // Show the victory modal with delayed animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (dialogContext) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: VictoryModal(
            roundNumber: currentRound,
            prizeAmount: prizeAmount,
            nextRoundSeconds: 60,
            isFinalRound: isFinalRound,
            totalRounds: _maxRounds,
            onClaimPrize: () {
              // Show loading spinner first
              _showLoadingOverlay(context);

              // After showing loading for 2 seconds, proceed to next round
              Future.delayed(const Duration(seconds: 2), () {
                if (!mounted) return;

                // Reset the game state but keep the current round
                final bingoBloc = context.read<BingoGameBloc>();
                bingoBloc.add(const ResetGame(isGameOver: false));

                // Increment the round counter if not in the final round
                setState(() {
                  if (_currentRound < _maxRounds) {
                    _currentRound++;
                    // Force timer recreation for next round
                    _timerKey++;
                  }
                });

                // Remove the loading overlay
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      );
    });
  }

  // Helper method to show loading overlay
  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (loadingContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: SpinKitCubeGrid(
              color: AppColors.yellowPrimary,
              size: 50.w,
            ),
          ),
        ),
      ),
    );
  }

  void _onTimeExpired() {
    // Player ran out of time, counts as a loss
    _playerLosses++;

    if (_playerLosses >= 2) {
      // Player has lost twice, show eliminated modal
      _showFinalLoseMessage();
    } else {
      // Player still has another chance, show lose modal
      _showLoseModal(false);
    }
  }

  void _showLoseModal(bool isEliminated) {
    final String winnerName = _generateRandomWinnerName();
    final bool isFinalRound = _currentRound >= _maxRounds;

    _soundService.playWrongBingo();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoseModal(
        round: _currentRound,
        winnerName: winnerName,
        isFinalRound: isFinalRound,
        totalRounds: _maxRounds,
        onContinue: () {
          // Navigation pop is now handled inside the LoseModal
          // No need to pop here

          if (isFinalRound) {
            // Game over, reset everything
            _playerLosses = 0; // Reset losses
            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: true));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else {
            // Go to next round - don't show eliminated modal
            setState(() {
              _currentRound++;
              // Increment timer key to force recreation of the GameTimeContainer
              _timerKey++;
            });
            // Reset the board for the next round
            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: false));
          }
        },
        onBackToHome: () {
          // Reset the game and go back home
          _playerLosses = 0; // Reset losses
          context.read<BingoGameBloc>().add(const ResetGame(isGameOver: true));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
      ),
    );
  }

  String _generateRandomWinnerName() {
    final aiNames = [
      'John Doe',
      'Jane Smith',
      'Mike Johnson',
      'Sarah Williams',
      'David Brown',
      'Emma Taylor',
      'Chris Wilson',
    ];

    return aiNames[Random().nextInt(aiNames.length)];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: AppDimension.isSmall ? 12.h : 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Game Title
                          Expanded(
                            child: Text(
                              'Hip-Hop Fire Round',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: AppDimension.isSmall ? 14.sp : 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // Time Container
                          Positioned(
                            right: AppDimension.isSmall ? 12.w : 16.w,
                            top: MediaQuery.of(context).padding.top + 16.h,
                            child: GameTimeContainer(
                              key: ValueKey(
                                  _timerKey), // Forces recreation when key changes
                              initialRound: _currentRound,
                              maxRounds: _maxRounds,
                              timePerRoundInSeconds: _timePerRound,
                              onRoundComplete: _onRoundComplete,
                              onTimeExpired: _onTimeExpired,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Player Container
                          const GamePlayerContainer(),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimension.isSmall ? 10.h : 14.h),

                    // Called Board Container
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const CalledBoardsContainer(),
                    ),

                    SizedBox(height: 16.h),

                    // Bingo Board Box Container
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const BingoBoardBoxContainer(),
                    ),
                  ],
                ),

                // Positioned Bingo Button
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppDimension.isSmall ? -6.h : 30.h,
                  child: BlocBuilder<BingoGameBloc, BingoGameState>(
                    buildWhen: (previous, current) =>
                        previous.hasWon != current.hasWon,
                    builder: (context, state) {
                      return BingoButton(
                        onPressed: () {
                          final bingoBloc = context.read<BingoGameBloc>();
                          bingoBloc.add(const ClaimBingo());

                          if (!state.hasWon) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    "No bingo yet! Keep playing.",
                                    style: AppTextStyle.mochiyPopOne(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),

                // Pattern change notification with full screen dismissibility
                BlocBuilder<BingoGameBloc, BingoGameState>(
                  buildWhen: (previous, current) =>
                      previous.winningPattern != current.winningPattern,
                  builder: (context, state) {
                    // Trigger animation when pattern changes
                    _animatePatternChange(state.winningPattern);

                    return AnimatedBuilder(
                      animation: _patternChangeAnimation,
                      builder: (context, child) {
                        // Ensure opacity is always between 0.0 and 1.0
                        final opacity =
                            _patternChangeAnimation.value.clamp(0.0, 1.0);

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
                                            borderRadius:
                                                BorderRadius.circular(24.r),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3.w,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.4),
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
                                                style:
                                                    AppTextStyle.mochiyPopOne(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              AppImages(
                                                imagePath: _winningPatterns[
                                                        state.winningPattern]![
                                                    'image'] as String,
                                                width: 60.w,
                                                height: 60.h,
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                _winningPatterns[
                                                        state.winningPattern]![
                                                    'title'] as String,
                                                style:
                                                    AppTextStyle.mochiyPopOne(
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
                ),

                // Bottom Navigation Icons
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 14.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Chat Icon
                        AppImages(
                          imagePath: AppImageData.chat,
                          width: 38.w,
                          height: 38.w,
                          onPressed: () {
                            // Play board tap sound with haptic feedback
                            _soundService.playBoardTap();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black54,
                              builder: (BuildContext context) => BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 24.w),
                                  child: ChatRoomModal(
                                    onClose: () => Navigator.of(context).pop(),
                                    userInitials: 'JD',
                                    activeUsers: 2500,
                                    isConnected: true,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 16.w),

                        // Winning Pattern Icon
                        BlocBuilder<BingoGameBloc, BingoGameState>(
                          buildWhen: (previous, current) =>
                              previous.winningPattern != current.winningPattern,
                          builder: (context, state) {
                            return AppImages(
                              imagePath: _winningPatterns[
                                  state.winningPattern]!['image'] as String,
                              width: 38.w,
                              height: 38.w,
                              onPressed: _showWinningPatternDetails,
                            );
                          },
                        ),
                        SizedBox(width: 16.w),

                        // Info Icon with SuperTooltip
                        GestureDetector(
                          onTap: () async {
                            // Play board tap sound with haptic feedback
                            _soundService.playBoardTap();

                            await _tooltipController.showTooltip();
                          },
                          child: SuperTooltip(
                            controller: _tooltipController,
                            popupDirection: TooltipDirection.up,
                            showBarrier: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            showDropBoxFilter: true,
                            sigmaX: 10,
                            sigmaY: 10,
                            arrowLength: 10.h,
                            arrowBaseWidth: 15.w,
                            borderColor: Colors.transparent,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.black54,
                            borderWidth: 0,
                            borderRadius: 16.r,
                            touchThroughAreaShape: ClipAreaShape.rectangle,
                            content: Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    "Hit Bingo button only if you have Bingo. If you call incorrectly more than twice, you will be eliminated from the round.",
                                    style: AppTextStyle.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ),
                            // The child of the SuperTooltip is the info icon
                            child: AppImages(
                              imagePath: AppImageData.info1,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bingo won overlay - removing this as it's redundant with BingoBoardBoxContainer
                BlocBuilder<BingoGameBloc, BingoGameState>(
                  buildWhen: (previous, current) =>
                      previous.hasWon != current.hasWon,
                  builder: (context, state) {
                    if (state.hasWon) {
                      // Show the victory modal with a short delay
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          // Show the victory modal with the current round number
                          _showRoundVictoryModal(context, state);
                        }
                      });
                    }
                    // Remove the overlay since we already have the animation in BingoBoardBoxContainer
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

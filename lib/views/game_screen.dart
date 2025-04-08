import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hiphop_rnb_bingo/widgets/app_background.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_board_box_container.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/victory_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';

// Import our new components
import 'package:hiphop_rnb_bingo/widgets/game_components/game_top_bar.dart';
import 'package:hiphop_rnb_bingo/widgets/game_components/game_bottom_nav.dart';
import 'package:hiphop_rnb_bingo/widgets/game_components/pattern_change_notification.dart';
import 'package:hiphop_rnb_bingo/widgets/game_components/game_modal_manager.dart';

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
      setState(() {
        _currentRound = currentRound;
      });

      if (currentRound >= _maxRounds) {
        // Game complete - user won all rounds
        _getModalManager().showFinalWinMessage(_playerLosses);
      }
    } else if (!didWin) {
      // User lost the round
      setState(() {
        _playerLosses++;
      });

      if (_playerLosses >= 2) {
        // Player has lost twice, show eliminated modal
        _getModalManager().showFinalLoseMessage(_playerLosses);
      } else {
        // Player still has another chance, show lose modal
        _getModalManager().showLoseModal(false, _currentRound, _playerLosses);
      }
    }
  }

  // Method to handle time expiration
  void _onTimeExpired() {
    // Player ran out of time, counts as a loss
    setState(() {
      _playerLosses++;
    });

    if (_playerLosses >= 2) {
      // Player has lost twice, show eliminated modal
      _getModalManager().showFinalLoseMessage(_playerLosses);
    } else {
      // Player still has another chance, show lose modal
      _getModalManager().showLoseModal(false, _currentRound, _playerLosses);
    }
  }

  void _updateCurrentRound(int round) {
    setState(() {
      _currentRound = round;
    });
  }

  void _updateTimerKey() {
    setState(() {
      _timerKey++;
    });
  }

  // Helper method to get GameModalManager instance
  GameModalManager _getModalManager() {
    return GameModalManager(
      context: context,
      soundService: _soundService,
      winningPatterns: _winningPatterns,
      updateCurrentRound: _updateCurrentRound,
      updateTimerKey: _updateTimerKey,
      maxRounds: _maxRounds,
    );
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Stack(
              children: [
                // Positioned Bingo Button - Now at the BOTTOM of the stack
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8.h,
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

                // Main column of game content - Now above the bingo button
                Column(
                  children: [
                    // Top Bar with game title, timer, and player count
                    GameTopBar(
                      currentRound: _currentRound,
                      maxRounds: _maxRounds,
                      timePerRound: _timePerRound,
                      timerKey: _timerKey,
                      onRoundComplete: _onRoundComplete,
                      onTimeExpired: _onTimeExpired,
                    ),

                    SizedBox(height: 16.h),

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

                // Pattern change notification
                PatternChangeNotification(
                  winningPatterns: _winningPatterns,
                ),

                // Bottom Navigation Icons
                GameBottomNav(
                  winningPatterns: _winningPatterns,
                  showWinningPatternDetails: () =>
                      _getModalManager().showWinningPatternDetails(),
                ),

                // Bingo win handler
                BlocBuilder<BingoGameBloc, BingoGameState>(
                  buildWhen: (previous, current) =>
                      previous.hasWon != current.hasWon,
                  builder: (context, state) {
                    if (state.hasWon) {
                      // Show the victory modal with a short delay
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          // Show the victory modal with the current round number
                          _getModalManager()
                              .showRoundVictoryModal(state, _currentRound);
                        }
                      });
                    }
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

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/views/home_screen.dart';
import 'package:hiphop_rnb_bingo/widgets/eliminated_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/lose_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/victory_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/game_components/winning_pattern_details_modal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';

class GameModalManager {
  final BuildContext context;
  final GameSoundService soundService;
  final Map<String, Map<String, dynamic>> winningPatterns;
  final Function(int) updateCurrentRound;
  final Function() updateTimerKey;
  final int maxRounds;

  GameModalManager({
    required this.context,
    required this.soundService,
    required this.winningPatterns,
    required this.updateCurrentRound,
    required this.updateTimerKey,
    required this.maxRounds,
  });

  void showWinningPatternDetails() {
    soundService.playBoardTap();

    final currentPattern = context.read<BingoGameBloc>().state.winningPattern;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: WinningPatternDetailsModal(
          winningPatterns: winningPatterns,
          currentPattern: currentPattern,
          soundService: soundService,
        ),
      ),
    );
  }

  void showFinalWinMessage(int playerLosses) {
    // Play prize win sound
    soundService.playPrizeWin();

    // Calculate the total prize amount for all rounds
    int grandTotalPrize = 0;
    for (int i = 1; i <= maxRounds; i++) {
      grandTotalPrize += 50 * i;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: VictoryModal(
          roundNumber: maxRounds,
          prizeAmount: grandTotalPrize,
          nextRoundSeconds: 60,
          isFinalRound: true,
          totalRounds: maxRounds,
          onClaimPrize: () {
            // Reset game for a potential next play
            updateCurrentRound(1); // Reset to first round
            updateTimerKey(); // Force timer recreation

            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: true));
          },
        ),
      ),
    );
  }

  void showFinalLoseMessage(int playerLosses) {
    // Play wrong bingo sound
    soundService.playWrongBingo();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: EliminatedModal(
          onTryAgain: () {
            // Reset game and go back to round 1
            updateCurrentRound(1); // Reset to first round
            updateTimerKey(); // Force timer recreation

            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: true));
          },
        ),
      ),
    );
  }

  void showLoseModal(bool isEliminated, int currentRound, int playerLosses) {
    final String winnerName = _generateRandomWinnerName();
    final bool isFinalRound = currentRound >= maxRounds;

    soundService.playWrongBingo();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoseModal(
        round: currentRound,
        winnerName: winnerName,
        isFinalRound: isFinalRound,
        totalRounds: maxRounds,
        onContinue: () {
          if (isFinalRound) {
            // Game over, reset everything
            updateCurrentRound(1); // Reset to first round
            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: true));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else {
            // Go to next round - don't show eliminated modal
            updateCurrentRound(currentRound + 1);
            updateTimerKey(); // Force timer recreation

            // Reset the board for the next round
            context
                .read<BingoGameBloc>()
                .add(const ResetGame(isGameOver: false));
          }
        },
        onBackToHome: () {
          // Reset the game and go back home
          updateCurrentRound(1); // Reset to first round
          context.read<BingoGameBloc>().add(const ResetGame(isGameOver: true));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
      ),
    );
  }

  void showRoundVictoryModal(BingoGameState state, int currentRound) {
    // Check if this is the final round
    bool isFinalRound = currentRound >= maxRounds;

    // Calculate prize amount - increase with rounds
    int prizeAmount = 50 * currentRound;

    // Show the victory modal with delayed animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;

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
            totalRounds: maxRounds,
            onClaimPrize: () {
              // Show loading spinner first
              _showLoadingOverlay();

              // After showing loading for 2 seconds, proceed to next round
              Future.delayed(const Duration(seconds: 2), () {
                if (!context.mounted) return;

                // Reset the game state but keep the current round
                final bingoBloc = context.read<BingoGameBloc>();
                bingoBloc.add(const ResetGame(isGameOver: false));

                // Increment the round counter if not in the final round
                if (currentRound < maxRounds) {
                  updateCurrentRound(currentRound + 1);
                  updateTimerKey();
                }

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
  void _showLoadingOverlay() {
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
}

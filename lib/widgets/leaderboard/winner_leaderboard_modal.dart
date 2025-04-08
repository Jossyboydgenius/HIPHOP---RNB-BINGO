import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/views/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_event.dart';

class PlayerScore {
  final String name;
  final int round;
  final double amount;
  final bool isCurrentPlayer;

  const PlayerScore({
    required this.name,
    required this.round,
    required this.amount,
    this.isCurrentPlayer = false,
  });
}

class WinnerLeaderboardModal extends StatefulWidget {
  final double totalAmount;
  final VoidCallback? onBackToHome;
  final bool updateBalance;

  const WinnerLeaderboardModal({
    super.key,
    required this.totalAmount,
    this.onBackToHome,
    this.updateBalance = true,
  });

  @override
  State<WinnerLeaderboardModal> createState() => _WinnerLeaderboardModalState();
}

class _WinnerLeaderboardModalState extends State<WinnerLeaderboardModal> {
  late List<PlayerScore> _leaderboard;
  final _soundService = GameSoundService();
  bool _hasUpdatedBalance = false;

  @override
  void initState() {
    super.initState();
    _generateLeaderboard();

    // Update the money balance on leaderboard display
    if (widget.updateBalance && !_hasUpdatedBalance) {
      _updateMoneyBalance();
      _hasUpdatedBalance = true;
    }
  }

  void _updateMoneyBalance() {
    try {
      // Get the current money balance from the bloc
      final currentBalance = context.read<BalanceBloc>().state.moneyBalance;

      // Add the total prize amount to the balance
      final amountToAdd = widget.totalAmount.toInt();

      if (amountToAdd > 0) {
        context
            .read<BalanceBloc>()
            .add(UpdateMoneyBalance(currentBalance + amountToAdd));
      }
    } catch (e) {
      print('Error updating money balance in leaderboard: $e');
    }
  }

  void _generateLeaderboard() {
    // Names for AI players
    final aiNames = [
      'John Doe',
      'Jane Doe',
      'Mike Smith',
      'Sarah Johnson',
      'David Brown',
      'Emma Wilson',
      'Chris Taylor',
    ];

    // Generate random scores for 3 rounds
    final Random random = Random();
    final List<PlayerScore> leaderboard = [];

    // Generate scores for first two rounds with AI players
    for (int i = 0; i < 2; i++) {
      final amount =
          (random.nextInt(7) + 3) * 10.0; // Random amount between $30-$90
      final aiName = aiNames[random.nextInt(aiNames.length)];

      leaderboard.add(PlayerScore(
        name: aiName,
        round: i + 1,
        amount: amount,
        isCurrentPlayer: false,
      ));
    }

    // Add the current player with their final round amount (the difference to make total)
    final currentPlayerAmount = widget.totalAmount -
        leaderboard.fold(0.0, (sum, player) => sum + player.amount);

    leaderboard.add(PlayerScore(
      name: 'John Doe', // Current player name
      round: 3,
      amount: currentPlayerAmount,
      isCurrentPlayer: true,
    ));

    setState(() {
      _leaderboard = leaderboard;
    });
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
              height: 550.h,
              fillColor: Colors.white,
              borderColor: Colors.white,
              layerColor: AppColors.purpleOverlay,
              showCloseButton: false,
              handleBackNavigation: true,
              onClose: () {},
              child: Column(
                children: [
                  SizedBox(height: 60.h),

                  // Title
                  Text(
                    'Winners Leaderboard',
                    style: AppTextStyle.mochiyPopOne(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),

                  // Scrollable leaderboard entries
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          for (int i = 0; i < _leaderboard.length; i++)
                            _buildLeaderboardItem(_leaderboard[i]),
                        ],
                      ),
                    ),
                  ),

                  // Fixed bottom section with reduced spacing
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Total amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            AppImages(
                              imagePath: AppImageData.money1,
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '\$${widget.totalAmount.toInt()}',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Back to home button
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: 'Back to Home',
                            textStyle: AppTextStyle.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            fillColor: AppColors.darkPurple,
                            layerColor: AppColors.darkPurple2,
                            extraLayerColor: AppColors.purpleOverlay,
                            extraLayerHeight:
                                AppDimension.isSmall ? 70.h : 50.h,
                            extraLayerTopPosition: 4.h,
                            extraLayerOffset: 1,
                            height: AppDimension.isSmall ? 70.h : 50.h,
                            layerHeight: AppDimension.isSmall ? 57.h : 44.h,
                            layerTopPosition: -1.5.h,
                            hasBorder: true,
                            borderColor: Colors.white,
                            onPressed: () {
                              _soundService.playButtonClick();
                              Navigator.of(context).pop();
                              if (widget.onBackToHome != null) {
                                widget.onBackToHome!();
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            borderRadius: 24.r,
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // "YOU WON" banner positioned above the modal
            Positioned(
              top: -95.h,
              child: AppImages(
                imagePath: AppImageData.won,
                width: 340.w,
                height: 140.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(PlayerScore player) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight2,
        borderRadius: BorderRadius.circular(100.r),
        border: player.isCurrentPlayer
            ? Border.all(color: AppColors.darkPurple4, width: 2.w)
            : Border.all(color: Colors.grey.withOpacity(0.3), width: 1.w),
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

          // Amount
          Text(
            '\$${player.amount.toInt()}',
            style: AppTextStyle.mochiyPopOne(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color:
                  player.isCurrentPlayer ? AppColors.darkPurple4 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

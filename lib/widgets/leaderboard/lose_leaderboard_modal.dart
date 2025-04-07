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

class LoseLeaderboardModal extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const LoseLeaderboardModal({
    super.key,
    this.onBackToHome,
  });

  @override
  State<LoseLeaderboardModal> createState() => _LoseLeaderboardModalState();
}

class _LoseLeaderboardModalState extends State<LoseLeaderboardModal> {
  late List<PlayerScore> _leaderboard;
  final _soundService = GameSoundService();

  @override
  void initState() {
    super.initState();
    _generateLeaderboard();
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

    // Generate random scores for 3 rounds with higher values for winners
    final Random random = Random();
    final List<PlayerScore> leaderboard = [];

    // Generate scores for 3 rounds with AI players (winners)
    for (int i = 0; i < 3; i++) {
      final amount =
          (random.nextInt(7) + 3) * 10.0; // Random amount between $30-$100
      final aiName = aiNames[random.nextInt(aiNames.length)];

      leaderboard.add(PlayerScore(
        name: aiName,
        round: i + 1,
        amount: amount,
        isCurrentPlayer: false,
      ));
    }

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
                    'Winners Leadboard',
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
                              '\$0',
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

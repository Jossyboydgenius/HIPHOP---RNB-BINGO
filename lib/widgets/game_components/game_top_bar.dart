import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/game_time_container.dart';
import 'package:hiphop_rnb_bingo/widgets/game_player_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';

class GameTopBar extends StatelessWidget {
  final int currentRound;
  final int maxRounds;
  final int timePerRound;
  final int timerKey;
  final Function(bool didWin, int currentRound) onRoundComplete;
  final VoidCallback onTimeExpired;

  const GameTopBar({
    Key? key,
    required this.currentRound,
    required this.maxRounds,
    required this.timePerRound,
    required this.timerKey,
    required this.onRoundComplete,
    required this.onTimeExpired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              key: ValueKey(timerKey), // Forces recreation when key changes
              initialRound: currentRound,
              maxRounds: maxRounds,
              timePerRoundInSeconds: timePerRound,
              onRoundComplete: onRoundComplete,
              onTimeExpired: onTimeExpired,
            ),
          ),
          SizedBox(width: 12.w),
          // Player Container
          const GamePlayerContainer(),
        ],
      ),
    );
  }
}

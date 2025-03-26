import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_background.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';
import 'package:hiphop_rnb_bingo/widgets/game_time_container.dart';
import 'package:hiphop_rnb_bingo/widgets/game_player_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_board_box_container.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
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
                    const GameTimeContainer(
                      time: "00:00",
                      round: 1,
                    ),
                    SizedBox(width: 12.w),
                    // Player Container
                    const GamePlayerContainer(
                      playerCount: 120,
                    ),
                  ],
                ),
              ),
              // Called Board Container
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const CalledBoardsContainer(),
              ),
              
              SizedBox(height: 16.h),
              
              // Bingo Board Box Container
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BingoBoardBoxContainer(
                  child: Container(), // We'll add the grid here later
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
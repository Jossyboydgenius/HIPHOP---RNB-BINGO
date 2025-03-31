import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
      'description': 'Mark 5 squares in a straight line (horizontal, vertical, or diagonal) to win.',
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

  void _showWinningPatternDetails() {
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
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  buildWhen: (previous, current) => previous.hasWon != current.hasWon,
                  builder: (context, state) {
                    return BingoButton(
                      onPressed: () {
                        final bingoBloc = context.read<BingoGameBloc>();
                        bingoBloc.add(CheckForWinningPattern(
                          patternType: bingoBloc.state.winningPattern
                        ));
                        
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

              // Bottom Navigation Icons
              Positioned(
                left: 0,
                right: 0,
                bottom: 14.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Chat Icon
                      AppImages(
                        imagePath: AppImageData.chat,
                        width: 38.w,
                        height: 38.w,
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            barrierColor: Colors.black54,
                            builder: (BuildContext context) => BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
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
                      SizedBox(width: 32.w),
                      
                      // Winning Pattern Icon
                      BlocBuilder<BingoGameBloc, BingoGameState>(
                        buildWhen: (previous, current) => 
                          previous.winningPattern != current.winningPattern,
                        builder: (context, state) {
                          return AppImages(
                            imagePath: _winningPatterns[state.winningPattern]!['image'] as String,
                            width: 38.w,
                            height: 38.w,
                            onPressed: _showWinningPatternDetails,
                          );
                        },
                      ),
                      SizedBox(width: 32.w),
                      
                      // Info Icon
                      AppImages(
                        imagePath: AppImageData.info1,
                        width: 38.w,
                        height: 38.w,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  "Hit Bingo button only if you have Bingo. If you call incorrectly more than twice, you will be eliminated from the round.",
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
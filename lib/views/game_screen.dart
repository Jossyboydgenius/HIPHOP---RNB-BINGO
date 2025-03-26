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
                bottom: -10.h,  // Changed from 80.h to -10.h
                child: BingoButton(
                  onPressed: () {
                    // Handle bingo button press
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
                      AppImages(
                        imagePath: _getWinningPatternIcon(),
                        width: 38.w,
                        height: 38.w,
                        onPressed: () {
                          // Handle pattern press
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
                                  style: AppTextStyle.poppins(
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

  String _getWinningPatternIcon() {
    // This will be dynamic based on game type from backend
    // For now, returning one of the patterns as default
    return AppImageData.straightlineBingo;
    
    // When implementing backend integration, you can use something like:
    /*
    switch (gameType) {
      case 'fourCorners':
        return AppImageData.fourCornersBingo;
      case 'blackout':
        return AppImageData.blackoutBingo;
      case 'straightLine':
        return AppImageData.straightlineBingo;
      case 'tShape':
        return AppImageData.tShapeBingo;
      case 'xPattern':
        return AppImageData.xPatternBingo;
      default:
        return AppImageData.straightlineBingo;
    }
    */
  }
} 
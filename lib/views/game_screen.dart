import 'dart:ui';
import 'dart:async';
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
import 'package:super_tooltip/super_tooltip.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _patternChangeController;
  late Animation<double> _patternChangeAnimation;
  String _lastPattern = '';
  Timer? _hideTimer;
  // Number of rounds in the game
  final int _maxRounds = 3;
  // Time per round in seconds
  final int _timePerRound = 120;
  
  // SuperTooltip controller
  final _tooltipController = SuperTooltipController();

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
    if (didWin && currentRound >= _maxRounds) {
      // Game complete - user won all rounds
      _showFinalWinMessage();
    } else if (!didWin) {
      // User lost the round
      _showFinalLoseMessage();
    }
  }
  
  void _showFinalWinMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.purplePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white, width: 3.w),
        ),
        title: Text(
          'Congratulations!',
          style: AppTextStyle.mochiyPopOne(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImages(
              imagePath: AppImageData.won,
              width: 120.w,
              height: 120.h,
            ),
            SizedBox(height: 16.h),
            Text(
              'You completed all $_maxRounds rounds successfully!',
              style: AppTextStyle.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Optionally reset game here if you want
              context.read<BingoGameBloc>().add(ResetGame());
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.greenBright,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                'Continue',
                style: AppTextStyle.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFinalLoseMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.purplePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white, width: 3.w),
        ),
        title: Text(
          'Game Over',
          style: AppTextStyle.mochiyPopOne(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImages(
              imagePath: AppImageData.lose,
              width: 120.w,
              height: 120.h,
            ),
            SizedBox(height: 16.h),
            Text(
              'You ran out of time. Try again!',
              style: AppTextStyle.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset game
              context.read<BingoGameBloc>().add(ResetGame(isGameOver: true));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.yellowPrimary,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                'Try Again',
                style: AppTextStyle.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                          // Update winning pattern
                          context.read<BingoGameBloc>().add(
                            CheckForWinningPattern(patternType: patternKey)
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.yellowPrimary : AppColors.purplePrimary,
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

  void _dismissPatternChange() {
    _hideTimer?.cancel();
    _patternChangeController.reverse();
  }

  // Method to handle back button when tooltip is visible
  Future<bool> _willPopCallback() async {
    if (_tooltipController.isVisible) {
      await _tooltipController.hideTooltip();
      return false;
    }
    return true;
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
                          GameTimeContainer(
                            initialRound: 1,
                            maxRounds: _maxRounds,
                            timePerRoundInSeconds: _timePerRound,
                            onRoundComplete: _onRoundComplete,
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
                    
                    return Stack(
                      children: [
                        // Full screen gesture detector to dismiss when tapping anywhere
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring: !_patternChangeAnimation.isCompleted,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: _dismissPatternChange,
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        
                        // Original pattern notification
                        Positioned(
                          top: 180.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _dismissPatternChange,
                            child: FadeTransition(
                              opacity: _patternChangeAnimation,
                              child: ScaleTransition(
                                scale: _patternChangeAnimation,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.purplePrimary,
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3.w,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
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
                                          style: AppTextStyle.mochiyPopOne(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        AppImages(
                                          imagePath: _winningPatterns[state.winningPattern]!['image'] as String,
                                          width: 60.w,
                                          height: 60.h,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          _winningPatterns[state.winningPattern]!['title'] as String,
                                          style: AppTextStyle.mochiyPopOne(
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
                        SizedBox(width: 16.w),
                        
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
                        SizedBox(width: 16.w),
                        
                        // Info Icon with SuperTooltip
                        GestureDetector(
                          onTap: () async {
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
                                  width: MediaQuery.of(context).size.width * 0.7,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sounds.dart';

class BingoBoardItem extends StatefulWidget {
  final String text;
  final BingoCategory category;
  final bool isCenter;
  final int index;

  const BingoBoardItem({
    super.key,
    required this.text,
    required this.category,
    this.isCenter = false,
    required this.index,
  });

  @override
  State<BingoBoardItem> createState() => _BingoBoardItemState();
}

class _BingoBoardItemState extends State<BingoBoardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  bool _showRipple = false;
  final _rippleKey = GlobalKey<_RippleEffectState>();

  // Track if this item has already played its part in a winning pattern sound
  bool _hasSoundedForPattern = false;
  final GameSoundService _soundService = GameSoundService();

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.12)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.12, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.05, end: 0.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.05, end: -0.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _animationController.repeat(reverse: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get categoryColor {
    switch (widget.category) {
      case BingoCategory.B:
        return AppColors.deepBlue1;
      case BingoCategory.I:
        return AppColors.deepYellow;
      case BingoCategory.N:
        return AppColors.deepPink;
      case BingoCategory.G:
        return AppColors.deepGreen;
      case BingoCategory.O:
        return AppColors.darkPurple1;
    }
  }

  String get categoryIcon {
    switch (widget.category) {
      case BingoCategory.B:
        return AppIconData.star3;
      case BingoCategory.I:
        return AppIconData.star;
      case BingoCategory.N:
        return AppIconData.star4;
      case BingoCategory.G:
        return AppIconData.star2;
      case BingoCategory.O:
        return AppIconData.star1;
    }
  }

  /// Checks if the current index is part of a winning pattern based on the pattern type
  bool _isPartOfWinningPattern(List<int> selectedItems, String patternType) {
    switch (patternType) {
      case 'straightlineBingo':
        // Row check
        final int row = widget.index ~/ 5;
        bool isRowComplete = true;
        for (int col = 0; col < 5; col++) {
          if (!selectedItems.contains(row * 5 + col)) {
            isRowComplete = false;
            break;
          }
        }
        if (isRowComplete) return true;

        // Column check
        final int col = widget.index % 5;
        bool isColComplete = true;
        for (int row = 0; row < 5; row++) {
          if (!selectedItems.contains(row * 5 + col)) {
            isColComplete = false;
            break;
          }
        }
        if (isColComplete) return true;

        // Diagonal check (top-left to bottom-right)
        if (widget.index % 6 == 0 && widget.index < 25) {
          // Indexes 0, 6, 12, 18, 24
          bool isDiag1Complete = true;
          for (int i = 0; i < 5; i++) {
            if (!selectedItems.contains(i * 5 + i)) {
              isDiag1Complete = false;
              break;
            }
          }
          if (isDiag1Complete) return true;
        }

        // Diagonal check (top-right to bottom-left)
        if ((widget.index == 4) ||
            (widget.index == 8) ||
            (widget.index == 12) ||
            (widget.index == 16) ||
            (widget.index == 20)) {
          bool isDiag2Complete = true;
          for (int i = 0; i < 5; i++) {
            if (!selectedItems.contains(i * 5 + (4 - i))) {
              isDiag2Complete = false;
              break;
            }
          }
          if (isDiag2Complete) return true;
        }

        return false;

      case 'blackoutBingo':
        // All cells need to be selected
        return selectedItems.length == 25;

      case 'fourCornersBingo':
        // Check if this is a corner and all corners are selected
        final bool isFourCorners = selectedItems.contains(0) &&
            selectedItems.contains(4) &&
            selectedItems.contains(20) &&
            selectedItems.contains(24);

        return isFourCorners &&
            (widget.index == 0 ||
                widget.index == 4 ||
                widget.index == 20 ||
                widget.index == 24);

      case 'tShapeBingo':
        // Top row or middle column
        final bool isTopRow = widget.index < 5;
        final bool isMiddleCol = widget.index % 5 == 2;
        final bool isTPattern = selectedItems.contains(0) &&
            selectedItems.contains(1) &&
            selectedItems.contains(2) &&
            selectedItems.contains(3) &&
            selectedItems.contains(4) &&
            selectedItems.contains(7) &&
            selectedItems.contains(12) &&
            selectedItems.contains(17) &&
            selectedItems.contains(22);

        return isTPattern && (isTopRow || isMiddleCol);

      case 'xPatternBingo':
        // Diagonals - check if index is part of either diagonal
        final bool isDiag1 = widget.index % 6 == 0 &&
            widget.index < 25; // Indexes 0, 6, 12, 18, 24
        final bool isDiag2 = (widget.index == 4) ||
            (widget.index == 8) ||
            (widget.index == 12) ||
            (widget.index == 16) ||
            (widget.index == 20);
        final bool isXPattern = selectedItems.contains(0) &&
            selectedItems.contains(6) &&
            selectedItems.contains(12) &&
            selectedItems.contains(18) &&
            selectedItems.contains(24) &&
            selectedItems.contains(4) &&
            selectedItems.contains(8) &&
            selectedItems.contains(16) &&
            selectedItems.contains(20);

        return isXPattern && (isDiag1 || isDiag2);

      default:
        return false;
    }
  }

  /// Checks if the current index is part of a potential winning pattern (before user claims bingo)
  bool _isPartOfPotentialWinningPattern(
      List<int> selectedItems, String patternType) {
    if (!selectedItems.contains(widget.index)) {
      return false; // This cell isn't even selected, so it can't be part of a winning pattern
    }

    return _isPartOfWinningPattern(selectedItems, patternType);
  }

  /// Checks if the current pattern is complete but hasn't been claimed yet
  bool _isPatternCompleteButNotClaimed(
      List<int> selectedItems, String patternType, bool hasWon) {
    if (hasWon) return false; // Pattern has already been claimed

    switch (patternType) {
      case 'straightlineBingo':
        // Check row
        final int row = widget.index ~/ 5;
        bool isRowComplete = true;
        for (int col = 0; col < 5; col++) {
          if (!selectedItems.contains(row * 5 + col)) {
            isRowComplete = false;
            break;
          }
        }
        if (isRowComplete) return true;

        // Check column
        final int col = widget.index % 5;
        bool isColComplete = true;
        for (int row = 0; row < 5; row++) {
          if (!selectedItems.contains(row * 5 + col)) {
            isColComplete = false;
            break;
          }
        }
        if (isColComplete) return true;

        // Check diagonal (top-left to bottom-right)
        bool isDiag1Complete = true;
        for (int i = 0; i < 5; i++) {
          if (!selectedItems.contains(i * 5 + i)) {
            isDiag1Complete = false;
            break;
          }
        }
        if (isDiag1Complete) return true;

        // Check diagonal (top-right to bottom-left)
        bool isDiag2Complete = true;
        for (int i = 0; i < 5; i++) {
          if (!selectedItems.contains(i * 5 + (4 - i))) {
            isDiag2Complete = false;
            break;
          }
        }
        return isDiag2Complete;

      case 'blackoutBingo':
        return selectedItems.length == 25;

      case 'fourCornersBingo':
        return selectedItems.contains(0) &&
            selectedItems.contains(4) &&
            selectedItems.contains(20) &&
            selectedItems.contains(24);

      case 'tShapeBingo':
        return selectedItems.contains(0) &&
            selectedItems.contains(1) &&
            selectedItems.contains(2) &&
            selectedItems.contains(3) &&
            selectedItems.contains(4) &&
            selectedItems.contains(7) &&
            selectedItems.contains(12) &&
            selectedItems.contains(17) &&
            selectedItems.contains(22);

      case 'xPatternBingo':
        return selectedItems.contains(0) &&
            selectedItems.contains(6) &&
            selectedItems.contains(12) &&
            selectedItems.contains(18) &&
            selectedItems.contains(24) &&
            selectedItems.contains(4) &&
            selectedItems.contains(8) &&
            selectedItems.contains(16) &&
            selectedItems.contains(20);

      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BingoGameBloc, BingoGameState>(
      buildWhen: (previous, current) =>
          previous.calledBoards != current.calledBoards ||
          previous.selectedItems != current.selectedItems ||
          previous.hasWon != current.hasWon,
      builder: (context, state) {
        final bool isCalled =
            widget.isCenter || state.isItemCalled(widget.text);
        final bool isSelected =
            widget.isCenter || state.isItemSelected(widget.index);
        final bool isWinningItem = state.hasWon &&
            isSelected &&
            _isPartOfWinningPattern(state.selectedItems, state.winningPattern);

        // Check if this is part of a potential winning pattern (before claiming bingo)
        final bool isPotentialWinningItem = !state.hasWon &&
            isSelected &&
            _isPartOfPotentialWinningPattern(
                state.selectedItems, state.winningPattern);

        // Check if pattern is complete but not yet claimed
        final bool isPatternCompleteNotClaimed =
            _isPatternCompleteButNotClaimed(
                state.selectedItems, state.winningPattern, state.hasWon);

        // The first item in a pattern should play the sound when pattern is complete
        if (isPatternCompleteNotClaimed &&
            !_hasSoundedForPattern &&
            isPotentialWinningItem) {
          // Only play once by tracking state
          _hasSoundedForPattern = true;

          // Play app launch sound when pattern is complete but not claimed
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _soundService.playSound(AppSoundData.appLaunch);
            _soundService.vibrateHeavy(); // Add strong haptic feedback
          });
        }

        // Reset the sound flag when selections change and pattern is no longer complete
        if (!isPatternCompleteNotClaimed) {
          _hasSoundedForPattern = false;
        }

        // Determine if we should show the star icon for this item
        final bool showIcon =
            widget.isCenter || isWinningItem || isPotentialWinningItem;

        // Adjust animation speed based on pattern completion status
        if (isPotentialWinningItem || isWinningItem) {
          // Fast animation for winning items
          if (_animationController.duration?.inMilliseconds != 600) {
            _animationController.stop();
            _animationController.duration = const Duration(milliseconds: 600);
            _animationController.repeat(reverse: false);
          }
        } else if (isSelected && !widget.isCenter) {
          // Normal animation for selected items
          if (_animationController.duration?.inMilliseconds != 1200) {
            _animationController.stop();
            _animationController.duration = const Duration(milliseconds: 1200);
            _animationController.repeat(reverse: false);
          }
        } else {
          // No animation for unselected items
          if (_animationController.isAnimating) {
            _animationController.stop();
            _animationController.reset();
          }
        }

        // Create the item container without gesture detector
        Widget itemContainer = AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected && !widget.isCenter
                  ? (isPotentialWinningItem || isWinningItem
                      ? _pulseAnimation.value
                      : isSelected
                          ? 1.05
                          : 1.0)
                  : 1.0,
              child: Transform.rotate(
                angle: (isPotentialWinningItem || isWinningItem)
                    ? _rotationAnimation.value
                    : 0,
                child: Stack(
                  children: [
                    // Main container
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? categoryColor
                            : categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? Colors.white : categoryColor,
                          width: isPotentialWinningItem || isWinningItem
                              ? 3.w
                              : 2.w,
                        ),
                        boxShadow: [
                          // Strong glow for winning pattern items
                          if (isPotentialWinningItem || isWinningItem)
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          // Medium glow for normal selected items
                          if (isSelected &&
                              !(isPotentialWinningItem || isWinningItem))
                            BoxShadow(
                              color: categoryColor.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          // Subtle outer glow for all items
                          if (isSelected)
                            BoxShadow(
                              color: categoryColor.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 4,
                            ),
                        ],
                      ),
                      child: Center(
                        child: showIcon
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Add a white glow behind the icon for winning pattern
                                  if (isPotentialWinningItem || isWinningItem)
                                    Container(
                                      width: 40.r,
                                      height: 40.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                  // Main icon
                                  AppIcons(
                                    icon: categoryIcon,
                                    size: 32.r,
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Text(
                                  widget.text,
                                  style: AppTextStyle.mochiyPopOne(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      ),
                    ),

                    // Ripple effect overlay
                    if (_showRipple)
                      RippleEffect(
                        key: _rippleKey,
                        color: categoryColor.withOpacity(0.5),
                        onComplete: () {
                          setState(() {
                            _showRipple = false;
                          });
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );

        // If it's the center item, return it directly without gesture detector
        if (widget.isCenter) {
          return itemContainer;
        }

        // For all other items, wrap in gesture detector
        return GestureDetector(
          onTap: () {
            // Play board tap sound with haptic feedback
            GameSoundService().playBoardTap();

            // Show ripple effect
            setState(() {
              _showRipple = true;
            });

            if (isCalled) {
              context.read<BingoGameBloc>().add(
                    SelectBingoItem(
                      text: widget.text,
                      category: widget.category,
                      index: widget.index,
                    ),
                  );
            }
          },
          child: itemContainer,
        );
      },
    );
  }
}

class RippleEffect extends StatefulWidget {
  final Color color;
  final VoidCallback onComplete;

  const RippleEffect({
    super.key,
    required this.color,
    required this.onComplete,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _radiusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
                // Use a FractionallySizedBox to animate from 0 to filling the parent
                child: FractionallySizedBox(
                  widthFactor: _radiusAnimation.value * 2,
                  heightFactor: _radiusAnimation.value * 2,
                  child: const SizedBox(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Add this extension for cleaner code
extension BingoCategoryColor on BingoCategory {
  Color get color {
    switch (this) {
      case BingoCategory.B:
        return AppColors.deepBlue1;
      case BingoCategory.I:
        return AppColors.deepYellow;
      case BingoCategory.N:
        return AppColors.deepPink;
      case BingoCategory.G:
        return AppColors.deepGreen;
      case BingoCategory.O:
        return AppColors.darkPurple1;
    }
  }
}

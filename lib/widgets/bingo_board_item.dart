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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showRipple = false;
  final _rippleKey = GlobalKey<_RippleEffectState>();

  @override
  void initState() {
    super.initState();

    // Setup pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
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

        // Determine if we should show the star icon for this item
        final bool showIcon =
            widget.isCenter || isWinningItem || isPotentialWinningItem;

        // Enable/disable pulse animation based on selection
        if (isSelected && !widget.isCenter) {
          if (_pulseController.status == AnimationStatus.dismissed) {
            _pulseController.repeat(reverse: true);
          }
        } else {
          if (_pulseController.status != AnimationStatus.dismissed) {
            _pulseController.reset();
          }
        }

        // Create the item container without gesture detector
        Widget itemContainer = AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  isSelected && !widget.isCenter ? _pulseAnimation.value : 1.0,
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
                        width: 2.w,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: categoryColor.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: categoryColor.withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: showIcon
                          ? AppIcons(
                              icon: categoryIcon,
                              size: 32.r,
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

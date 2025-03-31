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

class BingoBoardItem extends StatelessWidget {
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

  Color get categoryColor {
    switch (category) {
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
    switch (category) {
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
        final int row = index ~/ 5;
        bool isRowComplete = true;
        for (int col = 0; col < 5; col++) {
          if (!selectedItems.contains(row * 5 + col)) {
            isRowComplete = false;
            break;
          }
        }
        if (isRowComplete) return true;

        // Column check
        final int col = index % 5;
        bool isColComplete = true;
        for (int row = 0; row < 5; row++) {
          if (!selectedItems.contains(row * 5 + col)) {
            isColComplete = false;
            break;
          }
        }
        if (isColComplete) return true;

        // Diagonal check (top-left to bottom-right)
        if (index % 6 == 0 && index < 25) { // Indexes 0, 6, 12, 18, 24
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
        if ((index == 4) || (index == 8) || (index == 12) || (index == 16) || (index == 20)) {
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
        
        return isFourCorners && (index == 0 || index == 4 || index == 20 || index == 24);

      case 'tShapeBingo':
        // Top row or middle column
        final bool isTopRow = index < 5;
        final bool isMiddleCol = index % 5 == 2;
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
        final bool isDiag1 = index % 6 == 0 && index < 25; // Indexes 0, 6, 12, 18, 24
        final bool isDiag2 = (index == 4) || (index == 8) || (index == 12) || (index == 16) || (index == 20);
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BingoGameBloc, BingoGameState>(
      buildWhen: (previous, current) => 
        previous.calledBoards != current.calledBoards ||
        previous.selectedItems != current.selectedItems ||
        previous.hasWon != current.hasWon,
      builder: (context, state) {
        final bool isCalled = isCenter || state.isItemCalled(text);
        final bool isSelected = state.isItemSelected(index);
        final bool isWinningItem = state.hasWon && isSelected && 
                                  _isPartOfWinningPattern(state.selectedItems, state.winningPattern);
        
        // Create the item container without gesture detector
        Widget itemContainer = Container(
          decoration: BoxDecoration(
            color: isSelected 
                ? categoryColor 
                : categoryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.white : categoryColor,
              width: 2.w,
            ),
            boxShadow: isSelected ? [
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
            ] : null,
          ),
          child: Center(
            child: isCenter || isWinningItem
                ? AppIcons(
                    icon: categoryIcon,
                    size: 32.r,
                    // color: isWinningItem ? Colors.white : null,
                  )
                : Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Text(
                      text,
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
        );
        
        // If it's the center item, return it directly without gesture detector
        if (isCenter) {
          return itemContainer;
        }
        
        // For all other items, wrap in gesture detector
        return GestureDetector(
          onTap: () {
            if (isCalled) {
              context.read<BingoGameBloc>().add(
                SelectBingoItem(
                  text: text,
                  category: category,
                  index: index,
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
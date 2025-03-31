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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BingoGameBloc, BingoGameState>(
      buildWhen: (previous, current) => 
        previous.calledBoards != current.calledBoards ||
        previous.selectedItems != current.selectedItems,
      builder: (context, state) {
        final bool isCalled = isCenter || state.isItemCalled(text);
        final bool isSelected = state.isItemSelected(index);
        
        return GestureDetector(
          onTap: () {
            if (isCalled || isCenter) {
              context.read<BingoGameBloc>().add(
                SelectBingoItem(
                  text: text,
                  category: category,
                  index: index,
                ),
              );
            }
          },
          child: Container(
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
              child: isCenter 
                  ? AppIcons(
                      icon: categoryIcon,
                      size: 32.r,
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
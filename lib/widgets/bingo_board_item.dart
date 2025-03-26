import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';

class BingoBoardItem extends StatelessWidget {
  final String text;
  final BingoCategory category;
  final bool isCenter;

  const BingoBoardItem({
    super.key,
    required this.text,
    required this.category,
    this.isCenter = false,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: categoryColor,
          width: 2.w,
        ),
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
    );
  }
} 
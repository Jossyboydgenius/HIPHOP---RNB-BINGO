import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/models/called_board.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';

class BoardBox extends StatelessWidget {
  final CalledBoard board;

  const BoardBox({
    super.key,
    required this.board,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: board.categoryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: board.categoryColor,
          width: 2.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            board.name,
            style: AppTextStyle.mochiyPopOne(
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: board.progress,
            backgroundColor: board.categoryColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(board.categoryColor),
            minHeight: 2.h,
          ),
        ],
      ),
    );
  }
} 
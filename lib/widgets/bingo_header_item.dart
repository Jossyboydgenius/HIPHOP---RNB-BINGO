import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';

class BingoHeaderItem extends StatelessWidget {
  final String letter;
  final Color color;

  const BingoHeaderItem({
    super.key,
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.white,
          width: 2.w,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: AppTextStyle.mochiyPopOne(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} 
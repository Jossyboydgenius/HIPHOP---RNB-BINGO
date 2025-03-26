import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';

class BingoBoardBoxContainer extends StatelessWidget {
  final Widget child;

  const BingoBoardBoxContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Layer behind the main container
        Positioned(
          left: 0,
          right: 0,
          top: 4.h,
          child: Container(
            height: AppDimension.isSmall ? 380.h : 340.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        // Main container
        Container(
          width: double.infinity,
          height: AppDimension.isSmall ? 380.h : 340.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 2.w,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
} 
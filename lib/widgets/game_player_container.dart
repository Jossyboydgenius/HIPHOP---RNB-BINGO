import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';

class GamePlayerContainer extends StatefulWidget {
  final int? initialPlayerCount;

  const GamePlayerContainer({
    super.key,
    this.initialPlayerCount,
  });

  @override
  State<GamePlayerContainer> createState() => _GamePlayerContainerState();
}

class _GamePlayerContainerState extends State<GamePlayerContainer> {
  late int _playerCount;

  @override
  void initState() {
    super.initState();

    // Generate a random player count between 50 and 200 if not provided
    _playerCount = widget.initialPlayerCount ?? _generateRandomPlayerCount();
  }

  int _generateRandomPlayerCount() {
    final random = Random();
    return random.nextInt(151) + 50; // 50 to 200 range
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimension.isSmall ? 6.w : 4.w,
            vertical: AppDimension.isSmall ? 6.h : 4.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.yellowPrimary,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: Colors.white,
              width: AppDimension.isSmall ? 2.w : 1.5.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: AppDimension.isSmall ? 14.w : 14.w),
              Text(
                _playerCount.toString(),
                style: AppTextStyle.mochiyPopOne(
                  fontSize: AppDimension.isSmall ? 10.sp : 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: AppDimension.isSmall ? -12.w : -10.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: AppImages(
              imagePath: AppImageData.user,
              width: AppDimension.isSmall ? 32.w : 28.w,
              height: AppDimension.isSmall ? 32.h : 28.h,
            ),
          ),
        ),
      ],
    );
  }
}

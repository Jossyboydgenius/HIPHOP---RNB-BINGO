import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';

class CalledBoardsContainer extends StatelessWidget {
  const CalledBoardsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: AppDimension.isSmall ? 75.h : 65.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.grey,
                width: 2.w,
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 45.w),
              children: const [
                CalledBoardItem(
                  name: "Walk it Talk it / Fight Night",
                  category: BingoCategory.G,
                ),
                SizedBox(width: 6),
                CalledBoardItem(
                  name: "Ready for the World-love u",
                  category: BingoCategory.I,
                ),
                SizedBox(width: 6),
                CalledBoardItem(
                  name: "Come and Talk to Me",
                  category: BingoCategory.B,
                ),
              ],
            ),
          ),
          Positioned(
            left: -24.w,
            top: -6.h,
            child: AppImages(
              imagePath: AppImageData.bingoCard,
              width: AppDimension.isSmall ? 90.w : 80.w,
              height: AppDimension.isSmall ? 90.h : 80.h,
            ),
          ),
        ],
      ),
    );
  }
}

enum BingoCategory { B, I, N, G, O }

class CalledBoardItem extends StatefulWidget {
  final String name;
  final BingoCategory category;

  const CalledBoardItem({
    super.key,
    required this.name,
    required this.category,
  });

  @override
  State<CalledBoardItem> createState() => _CalledBoardItemState();
}

class _CalledBoardItemState extends State<CalledBoardItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: AppDimension.isSmall ? 80.w : 70.w,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: categoryColor,
            width: 2.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: categoryColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              borderRadius: BorderRadius.circular(4.r),
              minHeight: 2.h,
            ),
            SizedBox(height: 4.h),
            Text(
              widget.name,
              style: AppTextStyle.mochiyPopOne(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
} 
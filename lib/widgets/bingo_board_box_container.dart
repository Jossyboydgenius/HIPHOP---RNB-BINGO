import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_header_item.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_board_item.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';

class BingoBoardBoxContainer extends StatelessWidget {
  const BingoBoardBoxContainer({super.key});

  List<Widget> _buildBingoHeader() {
    return [
      const BingoHeaderItem(letter: 'B', color: AppColors.deepBlue1),
      const BingoHeaderItem(letter: 'I', color: AppColors.deepYellow),
      const BingoHeaderItem(letter: 'N', color: AppColors.deepPink),
      const BingoHeaderItem(letter: 'G', color: AppColors.deepGreen),
      const BingoHeaderItem(letter: 'O', color: AppColors.darkPurple1),
    ];
  }

  List<List<BingoBoardItem>> _buildBoardItems() {
    return [
      [
        const BingoBoardItem(text: "Come and Talk to Me", category: BingoCategory.B),
        const BingoBoardItem(text: "Forever my Lady", category: BingoCategory.I),
        const BingoBoardItem(text: "Feenin", category: BingoCategory.N),
        const BingoBoardItem(text: "Freek n You", category: BingoCategory.G),
        const BingoBoardItem(text: "Cry for you", category: BingoCategory.O),
      ],
      [
        const BingoBoardItem(text: "Real Love", category: BingoCategory.B),
        const BingoBoardItem(text: "Sweet Thing", category: BingoCategory.I),
        const BingoBoardItem(text: "I can Love You", category: BingoCategory.N),
        const BingoBoardItem(text: "I'm going down", category: BingoCategory.G),
        const BingoBoardItem(text: "Not Gon Cry", category: BingoCategory.O),
      ],
      [
        const BingoBoardItem(text: "Fantasy", category: BingoCategory.B),
        const BingoBoardItem(text: "Without You", category: BingoCategory.I),
        const BingoBoardItem(text: "", category: BingoCategory.N, isCenter: true),
        const BingoBoardItem(text: "Always Be My Baby", category: BingoCategory.G),
        const BingoBoardItem(text: "We Belong Together", category: BingoCategory.O),
      ],
      [
        const BingoBoardItem(text: "Bad & Bougie / T Shirt", category: BingoCategory.B),
        const BingoBoardItem(text: "Walk it Talk it / Fight Night", category: BingoCategory.I),
        const BingoBoardItem(text: "Slippery", category: BingoCategory.N),
        const BingoBoardItem(text: "Straightening", category: BingoCategory.G),
        const BingoBoardItem(text: "Handsome & Wealthy", category: BingoCategory.O),
      ],
      [
        const BingoBoardItem(text: "Dazz Band", category: BingoCategory.B),
        const BingoBoardItem(text: "Comodores", category: BingoCategory.I),
        const BingoBoardItem(text: "Earth Wind and Fire", category: BingoCategory.N),
        const BingoBoardItem(text: "Montel Jordan - This is How We..", category: BingoCategory.G),
        const BingoBoardItem(text: "Parliament-Funkadelic", category: BingoCategory.O),
      ],
    ];
  }

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
            height: AppDimension.isSmall ? 440.h : 400.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        // Main container
        Container(
          width: double.infinity,
          height: AppDimension.isSmall ? 440.h : 400.h,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 2.w,
            ),
          ),
          child: Column(
            children: [
              // BINGO Header Row
              SizedBox(
                height: 40.h,
                child: Row(
                  children: _buildBingoHeader()
                      .map((item) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: item,
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 8.h),
              // Bingo Board Grid
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                  ),
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    final row = index ~/ 5;
                    final col = index % 5;
                    return _buildBoardItems()[row][col];
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 
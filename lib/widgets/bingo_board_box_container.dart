import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_header_item.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_board_item.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';

class BingoBoardBoxContainer extends StatefulWidget {
  const BingoBoardBoxContainer({super.key});

  @override
  State<BingoBoardBoxContainer> createState() => _BingoBoardBoxContainerState();
}

class _BingoBoardBoxContainerState extends State<BingoBoardBoxContainer> {
  late List<BingoBoardItem> _shuffledItems;

  @override
  void initState() {
    super.initState();
    _shuffledItems = _generateShuffledBoardItems();
  }

  List<Widget> _buildBingoHeader() {
    return [
      const BingoHeaderItem(letter: 'B', color: AppColors.deepBlue1),
      const BingoHeaderItem(letter: 'I', color: AppColors.deepYellow),
      const BingoHeaderItem(letter: 'N', color: AppColors.deepPink),
      const BingoHeaderItem(letter: 'G', color: AppColors.deepGreen),
      const BingoHeaderItem(letter: 'O', color: AppColors.darkPurple1),
    ];
  }

  List<BingoBoardItem> _generateShuffledBoardItems() {
    // Define all items by category
    final bItems = [
      const BingoBoardItem(text: "Come and Talk to Me", category: BingoCategory.B),
      const BingoBoardItem(text: "Real Love", category: BingoCategory.B),
      const BingoBoardItem(text: "Fantasy", category: BingoCategory.B),
      const BingoBoardItem(text: "Bad & Bougie / T Shirt", category: BingoCategory.B),
      const BingoBoardItem(text: "Dazz Band", category: BingoCategory.B),
    ];
    
    final iItems = [
      const BingoBoardItem(text: "Forever my Lady", category: BingoCategory.I),
      const BingoBoardItem(text: "Sweet Thing", category: BingoCategory.I),
      const BingoBoardItem(text: "Without You", category: BingoCategory.I),
      const BingoBoardItem(text: "Walk it Talk it / Fight Night", category: BingoCategory.I),
      const BingoBoardItem(text: "Comodores", category: BingoCategory.I),
    ];
    
    final nItems = [
      const BingoBoardItem(text: "Feenin", category: BingoCategory.N),
      const BingoBoardItem(text: "I can Love You", category: BingoCategory.N),
      const BingoBoardItem(text: "", category: BingoCategory.N, isCenter: true),
      const BingoBoardItem(text: "Slippery", category: BingoCategory.N),
      const BingoBoardItem(text: "Earth Wind and Fire", category: BingoCategory.N),
    ];
    
    final gItems = [
      const BingoBoardItem(text: "Freek n You", category: BingoCategory.G),
      const BingoBoardItem(text: "I'm going down", category: BingoCategory.G),
      const BingoBoardItem(text: "Always Be My Baby", category: BingoCategory.G),
      const BingoBoardItem(text: "Straightening", category: BingoCategory.G),
      const BingoBoardItem(text: "Montel Jordan - This is How We..", category: BingoCategory.G),
    ];
    
    final oItems = [
      const BingoBoardItem(text: "Cry for you", category: BingoCategory.O),
      const BingoBoardItem(text: "Not Gon Cry", category: BingoCategory.O),
      const BingoBoardItem(text: "We Belong Together", category: BingoCategory.O),
      const BingoBoardItem(text: "Handsome & Wealthy", category: BingoCategory.O),
      const BingoBoardItem(text: "Parliament-Funkadelic", category: BingoCategory.O),
    ];
    
    // Shuffle each category separately
    _shuffleList(bItems);
    _shuffleList(iItems);
    // We need to keep the center item fixed
    final nonCenterNItems = [nItems[0], nItems[1], nItems[3], nItems[4]];
    _shuffleList(nonCenterNItems);
    _shuffleList(gItems);
    _shuffleList(oItems);
    
    // Create a list of all items
    final allItems = <BingoBoardItem>[];
    
    // First part of the board (before the center)
    for (int i = 0; i < 12; i++) {
      BingoBoardItem item;
      if (i % 5 == 0) item = bItems[i ~/ 5];
      else if (i % 5 == 1) item = iItems[i ~/ 5];
      else if (i % 5 == 2) item = i ~/ 5 < 2 ? nonCenterNItems[i ~/ 5] : nonCenterNItems[i ~/ 5 - 1];
      else if (i % 5 == 3) item = gItems[i ~/ 5];
      else item = oItems[i ~/ 5];
      
      allItems.add(item);
    }
    
    // Add center item
    allItems.add(nItems[2]); // Center is always fixed with the star
    
    // Last part of the board (after the center)
    for (int i = 13; i < 25; i++) {
      BingoBoardItem item;
      if (i % 5 == 0) item = bItems[i ~/ 5];
      else if (i % 5 == 1) item = iItems[i ~/ 5];
      else if (i % 5 == 2) item = i ~/ 5 < 3 ? nonCenterNItems[i ~/ 5 - 1] : nonCenterNItems[i ~/ 5 - 2];
      else if (i % 5 == 3) item = gItems[i ~/ 5];
      else item = oItems[i ~/ 5];
      
      allItems.add(item);
    }
    
    // Shuffle the entire board while keeping the center fixed
    final centerItem = allItems[12];
    final itemsWithoutCenter = [...allItems];
    itemsWithoutCenter.removeAt(12);
    _shuffleList(itemsWithoutCenter);
    
    // Reinsert the center item
    final result = [...itemsWithoutCenter];
    result.insert(12, centerItem);
    
    return result;
  }
  
  void _shuffleList(List list) {
    final random = Random();
    for (int i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
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
            height: AppDimension.isSmall ? 440.h : 390.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        // Main container
        Container(
          width: double.infinity,
          height: AppDimension.isSmall ? 440.h : 390.h,
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
                    return _shuffledItems[index];
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
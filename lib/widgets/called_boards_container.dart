import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_event.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_state.dart';

class CalledBoardsContainer extends StatefulWidget {
  const CalledBoardsContainer({super.key});

  @override
  State<CalledBoardsContainer> createState() => _CalledBoardsContainerState();
}

class _CalledBoardsContainerState extends State<CalledBoardsContainer> {
  final List<Map<String, dynamic>> _allPossibleBoards = [
    {'name': 'Walk it Talk it / Fight Night', 'category': BingoCategory.G},
    {'name': 'Ready for the World-love u', 'category': BingoCategory.I},
    {'name': 'Come and Talk to Me', 'category': BingoCategory.B},
    {'name': 'Fantasy', 'category': BingoCategory.B},
    {'name': 'Feenin', 'category': BingoCategory.N},
    {'name': 'Freek n You', 'category': BingoCategory.G},
    {'name': 'We Belong Together', 'category': BingoCategory.O},
    {'name': 'Slippery', 'category': BingoCategory.N},
    {'name': 'Sweet Thing', 'category': BingoCategory.I},
    {'name': 'Not Gon Cry', 'category': BingoCategory.O},
  ];
  
  int _currentIndex = 0;
  Timer? _timer;
  List<String> _animatedItems = [];
  
  @override
  void initState() {
    super.initState();
    // Start the simulation
    _startSimulation();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startSimulation() {
    // Call first board immediately
    _callNextBoard();
    
    // Set up timer to call a new board every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _callNextBoard();
      
      // Stop timer when all boards are called
      if (_currentIndex >= _allPossibleBoards.length) {
        timer.cancel();
      }
    });
  }
  
  void _callNextBoard() {
    if (_currentIndex < _allPossibleBoards.length) {
      final board = _allPossibleBoards[_currentIndex];
      final name = board['name'] as String;
      
      context.read<BingoGameBloc>().add(
        CallBoardItem(
          name: name,
          category: board['category'] as BingoCategory,
        ),
      );
      
      // Track the item we just added so we know to animate it
      setState(() {
        _animatedItems.add(name);
      });
      
      // Clear animation status after animation is likely complete
      Future.delayed(const Duration(milliseconds: 850), () {
        if (mounted) {
          setState(() {
            _animatedItems.remove(name);
          });
        }
      });
      
      _currentIndex++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BingoGameBloc, BingoGameState>(
      builder: (context, state) {
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 60.w, right: 12.w),
                  itemCount: state.calledBoards.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final board = state.calledBoards[index];
                    final name = board['name'] as String;
                    
                    // An item should animate if it's currently in our _animatedItems list
                    final shouldAnimate = _animatedItems.contains(name);
                    
                    return CalledBoardItem(
                      name: name,
                      category: board['category'] as BingoCategory,
                      isNewest: shouldAnimate,
                    );
                  },
                ),
              ),
              Positioned(
                left: AppDimension.isSmall ? -18.w : -14.w,
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
      },
    );
  }
}

enum BingoCategory { B, I, N, G, O }

class CalledBoardItem extends StatefulWidget {
  final String name;
  final BingoCategory category;
  final bool isNewest;

  const CalledBoardItem({
    super.key,
    required this.name,
    required this.category,
    this.isNewest = false,
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    if (widget.isNewest) {
      _controller.forward();
    } else {
      _controller.value = 1.0; // Already shown
    }
  }

  @override
  void didUpdateWidget(CalledBoardItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger animation if isNewest changed from false to true
    if (!oldWidget.isNewest && widget.isNewest) {
      _controller.reset();
      _controller.forward();
    }
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
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: categoryColor,
            width: 2.w,
          ),
        ),
        child: Center(
          child: Text(
            widget.name,
            style: AppTextStyle.mochiyPopOne(
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
} 
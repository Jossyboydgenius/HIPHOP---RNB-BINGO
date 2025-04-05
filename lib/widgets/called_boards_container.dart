import 'dart:async';
import 'dart:math';
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
  // List of all available board items from all categories
  final List<Map<String, dynamic>> _allBoardItems = [];

  final Random _random = Random();
  Timer? _timer;
  List<String> _animatedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the complete list of board items
    _initializeBoardItems();
    // Start the simulation
    _startSimulation();
  }

  void _initializeBoardItems() {
    // B category items
    _allBoardItems.addAll([
      {'name': 'Come and Talk to Me', 'category': BingoCategory.B},
      {'name': 'Real Love', 'category': BingoCategory.B},
      {'name': 'Fantasy', 'category': BingoCategory.B},
      {'name': 'Bad & Bougie / T Shirt', 'category': BingoCategory.B},
      {'name': 'Dazz Band', 'category': BingoCategory.B},
      // Additional B items
      {'name': 'Before I Let You Go', 'category': BingoCategory.B},
      {'name': 'Breakin\' My Heart', 'category': BingoCategory.B},
      {'name': 'Beautiful', 'category': BingoCategory.B},
    ]);

    // I category items
    _allBoardItems.addAll([
      {'name': 'Forever my Lady', 'category': BingoCategory.I},
      {'name': 'Sweet Thing', 'category': BingoCategory.I},
      {'name': 'Without You', 'category': BingoCategory.I},
      {'name': 'Walk it Talk it / Fight Night', 'category': BingoCategory.I},
      {'name': 'Comodores', 'category': BingoCategory.I},
      // Additional I items
      {'name': 'If I Ever Fall In Love', 'category': BingoCategory.I},
      {'name': 'I Wanna Be Down', 'category': BingoCategory.I},
      {'name': 'I\'ll Make Love To You', 'category': BingoCategory.I},
    ]);

    // N category items (excluding center)
    _allBoardItems.addAll([
      {'name': 'Feenin', 'category': BingoCategory.N},
      {'name': 'I can Love You', 'category': BingoCategory.N},
      {'name': 'Slippery', 'category': BingoCategory.N},
      {'name': 'Earth Wind and Fire', 'category': BingoCategory.N},
      // Additional N items
      {'name': 'Never Too Much', 'category': BingoCategory.N},
      {'name': 'No Diggity', 'category': BingoCategory.N},
    ]);

    // G category items
    _allBoardItems.addAll([
      {'name': 'Freek n You', 'category': BingoCategory.G},
      {'name': 'I\'m going down', 'category': BingoCategory.G},
      {'name': 'Always Be My Baby', 'category': BingoCategory.G},
      {'name': 'Straightening', 'category': BingoCategory.G},
      {'name': 'Montel Jordan - This is How We..', 'category': BingoCategory.G},
      // Additional G items
      {'name': 'Groove Me', 'category': BingoCategory.G},
      {'name': 'Gotta Get You Home', 'category': BingoCategory.G},
    ]);

    // O category items
    _allBoardItems.addAll([
      {'name': 'Cry for you', 'category': BingoCategory.O},
      {'name': 'Not Gon Cry', 'category': BingoCategory.O},
      {'name': 'We Belong Together', 'category': BingoCategory.O},
      {'name': 'Handsome & Wealthy', 'category': BingoCategory.O},
      {'name': 'Parliament-Funkadelic', 'category': BingoCategory.O},
      // Additional O items
      {'name': 'On Bended Knee', 'category': BingoCategory.O},
      {'name': 'One Sweet Day', 'category': BingoCategory.O},
    ]);

    // Shuffle the list for randomness
    _allBoardItems.shuffle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    // Call first board immediately
    _callNextBoard();

    // Set up timer to call a new board every 3 seconds (changed from 5)
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _callNextBoard();
    });
  }

  void _callNextBoard() {
    // Get a random board item that hasn't been called yet
    final currentState = context.read<BingoGameBloc>().state;
    final calledNames = currentState.calledBoards
        .map((board) => board['name'] as String)
        .toList();

    // Debug print for tracking
    print('Currently called boards: ${calledNames.length}');
    print('Available board items: ${_allBoardItems.length}');

    // Create a list of items that haven't been called yet
    final availableItems = _allBoardItems.where((board) {
      final name = board['name'] as String;
      return name.isNotEmpty && !calledNames.contains(name);
    }).toList();

    print('Uncalled items: ${availableItems.length}');

    // If all valid items have been called
    if (availableItems.isEmpty) {
      print('All items have been called, recycling older items');
      // Get all non-empty items
      final allValidItems = _allBoardItems
          .where((board) => board['name'].toString().isNotEmpty)
          .toList();

      // Shuffle to get random order
      allValidItems.shuffle(_random);

      // Find an item that wasn't recently called (not in the last 3 calls)
      final recentCalls = calledNames.take(3).toList();

      for (final item in allValidItems) {
        final name = item['name'] as String;
        if (!recentCalls.contains(name)) {
          // Call this item again
          context.read<BingoGameBloc>().add(
                CallBoardItem(
                  name: name,
                  category: item['category'] as BingoCategory,
                ),
              );

          // Track the item for animation
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

          return;
        }
      }

      // If we get here, just pick any random item
      final randomItem = allValidItems[_random.nextInt(allValidItems.length)];
      final name = randomItem['name'] as String;

      context.read<BingoGameBloc>().add(
            CallBoardItem(
              name: name,
              category: randomItem['category'] as BingoCategory,
            ),
          );

      setState(() {
        _animatedItems.add(name);
      });

      Future.delayed(const Duration(milliseconds: 850), () {
        if (mounted) {
          setState(() {
            _animatedItems.remove(name);
          });
        }
      });

      return;
    }

    // Get a random item from available ones
    final int randomIndex = _random.nextInt(availableItems.length);
    final board = availableItems[randomIndex];
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

class _CalledBoardItemState extends State<CalledBoardItem>
    with SingleTickerProviderStateMixin {
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
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

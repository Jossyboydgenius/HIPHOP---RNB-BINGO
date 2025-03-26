import 'dart:ui';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';

enum BingoCategory {
  B,
  I,
  N,
  G,
  O,
}

class CalledBoard {
  final String name;
  final BingoCategory category;
  final double progress;

  CalledBoard({
    required this.name,
    required this.category,
    this.progress = 0.0,
  });

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
} 
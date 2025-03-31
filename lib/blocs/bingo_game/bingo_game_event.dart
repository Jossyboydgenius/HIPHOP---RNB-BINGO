import 'package:equatable/equatable.dart';
import 'package:hiphop_rnb_bingo/widgets/called_boards_container.dart';

abstract class BingoGameEvent extends Equatable {
  const BingoGameEvent();

  @override
  List<Object?> get props => [];
}

class CallBoardItem extends BingoGameEvent {
  final String name;
  final BingoCategory category;

  const CallBoardItem({
    required this.name,
    required this.category,
  });

  @override
  List<Object?> get props => [name, category];
}

class SelectBingoItem extends BingoGameEvent {
  final String text;
  final BingoCategory category;
  final int index;

  const SelectBingoItem({
    required this.text,
    required this.category,
    required this.index,
  });

  @override
  List<Object?> get props => [text, category, index];
}

class CheckForWinningPattern extends BingoGameEvent {
  final String patternType;

  const CheckForWinningPattern({
    required this.patternType,
  });

  @override
  List<Object?> get props => [patternType];
}

class ResetGame extends BingoGameEvent {} 
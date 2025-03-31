import 'package:equatable/equatable.dart';

class BingoGameState extends Equatable {
  final List<Map<String, dynamic>> calledBoards;
  final List<int> selectedItems;
  final bool hasWon;
  final String winningPattern;

  const BingoGameState({
    this.calledBoards = const [],
    this.selectedItems = const [],
    this.hasWon = false,
    this.winningPattern = 'straightlineBingo',
  });

  factory BingoGameState.initial() {
    return const BingoGameState();
  }

  bool isItemCalled(String text) {
    return calledBoards.any((board) => board['name'] == text);
  }

  bool isItemSelected(int index) {
    return selectedItems.contains(index);
  }

  BingoGameState copyWith({
    List<Map<String, dynamic>>? calledBoards,
    List<int>? selectedItems,
    bool? hasWon,
    String? winningPattern,
  }) {
    return BingoGameState(
      calledBoards: calledBoards ?? this.calledBoards,
      selectedItems: selectedItems ?? this.selectedItems,
      hasWon: hasWon ?? this.hasWon,
      winningPattern: winningPattern ?? this.winningPattern,
    );
  }

  @override
  List<Object?> get props => [calledBoards, selectedItems, hasWon, winningPattern];
} 
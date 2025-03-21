class BalanceState {
  final int gemBalance;
  final int boardBalance;

  BalanceState({
    required this.gemBalance,
    required this.boardBalance,
  });

  factory BalanceState.initial() {
    return BalanceState(
      gemBalance: 1200,
      boardBalance: 120,
    );
  }

  BalanceState copyWith({
    int? gemBalance,
    int? boardBalance,
  }) {
    return BalanceState(
      gemBalance: gemBalance ?? this.gemBalance,
      boardBalance: boardBalance ?? this.boardBalance,
    );
  }
} 
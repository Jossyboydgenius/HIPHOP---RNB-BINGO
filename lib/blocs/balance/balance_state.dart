import 'package:equatable/equatable.dart';

class BalanceState extends Equatable {
  final int gemBalance;
  final int boardBalance;
  final int moneyBalance;

  const BalanceState({
    this.gemBalance = 0,
    this.boardBalance = 0,
    this.moneyBalance = 0,
  });

  factory BalanceState.initial() {
    return const BalanceState(
      gemBalance: 1200,
      boardBalance: 120,
    );
  }

  BalanceState copyWith({
    int? gemBalance,
    int? boardBalance,
    int? moneyBalance,
  }) {
    return BalanceState(
      gemBalance: gemBalance ?? this.gemBalance,
      boardBalance: boardBalance ?? this.boardBalance,
      moneyBalance: moneyBalance ?? this.moneyBalance,
    );
  }

  @override
  List<Object?> get props => [gemBalance, boardBalance, moneyBalance];
}

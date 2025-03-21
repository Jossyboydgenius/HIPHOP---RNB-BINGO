abstract class BalanceEvent {}

class UpdateGemBalance extends BalanceEvent {
  final int newBalance;
  UpdateGemBalance(this.newBalance);
}

class UpdateBoardBalance extends BalanceEvent {
  final int newBalance;
  UpdateBoardBalance(this.newBalance);
} 
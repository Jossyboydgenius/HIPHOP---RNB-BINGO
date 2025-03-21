import 'package:flutter_bloc/flutter_bloc.dart';
import 'balance_event.dart';
import 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc() : super(BalanceState.initial()) {
    on<UpdateGemBalance>((event, emit) {
      emit(state.copyWith(gemBalance: event.newBalance));
    });

    on<UpdateBoardBalance>((event, emit) {
      emit(state.copyWith(boardBalance: event.newBalance));
    });
  }
} 
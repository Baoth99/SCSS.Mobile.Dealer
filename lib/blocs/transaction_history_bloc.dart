import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();

  TransactionHistoryBloc() : super(TransactionHistoryState()) {
    add(EventInitData());
  }

  final _initPage = 1;
  final _pageSize = 10;
  int _currentPage = 1;

  @override
  Stream<TransactionHistoryState> mapEventToState(
      TransactionHistoryEvent event) async* {
    if (event is EventInitData) {
      yield state.copyWith(process: TransactionHistoryProcess.processing);
      try {
        _currentPage = 1;

        List<CollectDealTransactionModel> transactionList =
            await collectDealTransactionHandler.getCollectDealHistories(
          page: _initPage,
          pageSize: _pageSize,
          fromDate: state.fromDate,
          toDate: state.toDate,
          fromTotal: state.fromTotal,
          toTotal: state.toTotal,
        );
        yield state.copyWith(transactionList: transactionList);
        yield state.copyWith(process: TransactionHistoryProcess.processed);
      } catch (e) {
        print(e);
        yield state.copyWith(process: TransactionHistoryProcess.processed);
        //  if (e.toString().contains(CustomTexts.missingBearerToken))
        // print(e);
      } finally {
        yield state.copyWith(process: TransactionHistoryProcess.neutral);
      }
    }
    if (event is EventLoadMoreTransactions) {
      yield state.copyWith(process: TransactionHistoryProcess.processing);
      try {
        // Clone list
        var list =
            List<CollectDealTransactionModel>.from(state.transactionList);
        // Get new transactions
        List<CollectDealTransactionModel> newList =
            await collectDealTransactionHandler.getCollectDealHistories(
          page: _currentPage + 1,
          pageSize: _pageSize,
          fromDate: state.fromDate,
          toDate: state.toDate,
          fromTotal: state.fromTotal,
          toTotal: state.toTotal,
        );
        // If there is more transactions
        if (newList.isNotEmpty) {
          _currentPage += 1;
          list.addAll(newList);
          yield state.copyWith(transactionList: list);
        }
        yield state.copyWith(process: TransactionHistoryProcess.processed);
      } catch (e) {
        yield state.copyWith(process: TransactionHistoryProcess.processed);
        //  if (e.toString().contains(CustomTexts.missingBearerToken))
        // print(e);
      } finally {
        yield state.copyWith(process: TransactionHistoryProcess.neutral);
      }
    }
    if (event is EventChangeTotalRange) {
      yield state.copyWith(
        fromTotal: event.startValue.toInt(),
        toTotal: event.endValue.toInt(),
      );
    }
    if (event is EventChangeDate) {
      yield state.copyWith(
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
    }
    if (event is EventResetFilter) {
      yield state.resetFilter();
      add(EventInitData());
    }
  }
}

import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_history_detail_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionHistoryDetailBloc
    extends Bloc<TransactionHistoryDetailEvent, TransactionHistoryDetailState> {
  final collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();
  final dataHandler = getIt.get<IDataHandler>();

  TransactionHistoryDetailBloc({required this.id}) : super(NotLoadedState()) {
    add(EventInitData());
  }

  final String id;

  @override
  Stream<TransactionHistoryDetailState> mapEventToState(
      TransactionHistoryDetailEvent event) async* {
    if (event is EventInitData) {
      var grandTotal;
      try {
        CDTransactionHistoryDetailModel model =
            await collectDealTransactionHandler.getCollectDealHistoryDetail(
                id: id);
        grandTotal = model.total + model.totalBonus;
        yield LoadedState(model: model, grandTotal: grandTotal);
      } catch (e) {
        print(e);
        //  if (e.toString().contains(CustomTexts.missingBearerToken))
        // print(e);
      }
    }
    // if (event is EventLoadMoreTransactions) {
    //   yield state.copyWith(process: TransactionDetailProcess.processing);
    //   try {
    //     // Clone list
    //     var list =
    //         List<CollectDealTransactionModel>.from(state.transactionList);
    //     // Get new transactions
    //     List<CollectDealTransactionModel> newList =
    //         await collectDealTransactionHandler.getCollectDealHistories(
    //       page: _currentPage + 1,
    //       pageSize: _pageSize,
    //       fromDate: state.fromDate,
    //       toDate: state.toDate,
    //       fromTotal: state.fromTotal,
    //       toTotal: state.toTotal,
    //     );
    //     // If there is more transactions
    //     if (newList.isNotEmpty) {
    //       _currentPage += 1;
    //       list.addAll(newList);
    //       yield state.copyWith(
    //           transactionList: list,
    //           filteredTransactionList: _getTransactionListPhoneFiltered(
    //             transactionList: list,
    //             name: state.searchName,
    //           ));
    //     }
    //     yield state.copyWith(process: TransactionDetailProcess.processed);
    //   } catch (e) {
    //     yield state.copyWith(process: TransactionDetailProcess.processed);
    //     //  if (e.toString().contains(CustomTexts.missingBearerToken))
    //     // print(e);
    //   } finally {
    //     yield state.copyWith(process: TransactionDetailProcess.neutral);
    //   }
    // }
    // if (event is EventChangeTotalRange) {
    //   yield state.copyWith(
    //     fromTotal: event.startValue.toInt(),
    //     toTotal: event.endValue.toInt(),
    //   );
    // }
    // if (event is EventChangeDate) {
    //   yield state.copyWith(
    //     fromDate: event.fromDate,
    //     toDate: event.toDate,
    //   );
    // }
    // if (event is EventResetFilter) {
    //   yield state.resetFilter();
    //   add(EventInitData());
    // }
    // if (event is EventChangeSearchName) {
    //   yield state.copyWith(
    //       searchPhone: event.searchName,
    //       filteredTransactionList: _getTransactionListPhoneFiltered(
    //         transactionList: state.transactionList,
    //         name: event.searchName,
    //       ));
    // }
  }
}

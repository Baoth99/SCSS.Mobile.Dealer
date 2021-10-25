import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_detail_event.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/states/transaction_detail_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  final collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();
  final dataHandler = getIt.get<IDataHandler>();

  TransactionDetailBloc({required initialState}) : super(initialState);

  @override
  Stream<TransactionDetailState> mapEventToState(
      TransactionDetailEvent event) async* {
    // if (event is EventInitData) {
    //   yield state.copyWith(process: TransactionDetailProcess.processing);
    //   try {
    //     _currentPage = 1;

    //     _collectorList = await dataHandler.getCollectorPhoneList();

    //     List<CollectDealTransactionModel> transactionList =
    //         await collectDealTransactionHandler.getCollectDealHistories(
    //       page: _initPage,
    //       pageSize: _pageSize,
    //       fromDate: state.fromDate,
    //       toDate: state.toDate,
    //       fromTotal: state.fromTotal,
    //       toTotal: state.toTotal,
    //     );
    //     yield state.copyWith(
    //         transactionList: transactionList,
    //         filteredTransactionList: _getTransactionListPhoneFiltered(
    //           transactionList: transactionList,
    //           name: state.searchName,
    //         ));
    //     yield state.copyWith(process: TransactionDetailProcess.processed);
    //   } catch (e) {
    //     print(e);
    //     yield state.copyWith(process: TransactionDetailProcess.error);
    //     //  if (e.toString().contains(CustomTexts.missingBearerToken))
    //     // print(e);
    //   } finally {
    //     yield state.copyWith(process: TransactionDetailProcess.neutral);
    //   }
    // }
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

  List<CollectDealTransactionModel> _getTransactionListPhoneFiltered(
      {required List<CollectDealTransactionModel> transactionList,
      required String name}) {
    if (name == CustomTexts.emptyString) return transactionList;
    // Check transactionList
    if (transactionList.isEmpty) return List.empty();
    // return filtered List
    var list = transactionList
        .where((element) =>
            element.collectorName.toLowerCase().contains(name.toLowerCase()))
        .toList();
    return list;
  }
}

import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';

enum TransactionDetailProcess {
  neutral,
  processing,
  processed,
  error,
  valid,
  invalid,
}

class TransactionDetailState {
  TransactionDetailProcess process;
  CollectDealTransactionModel transaction;

  TransactionDetailState({
    TransactionDetailProcess? process,
    required CollectDealTransactionModel transaction,
  })  : process = process ?? TransactionDetailProcess.neutral,
        transaction = transaction;

  TransactionDetailState copyWith({
    TransactionDetailProcess? process,
    CollectDealTransactionModel? transactionList,
  }) {
    return TransactionDetailState(
      process: process ?? this.process,
      transaction: transactionList ?? this.transaction,
    );
  }
}

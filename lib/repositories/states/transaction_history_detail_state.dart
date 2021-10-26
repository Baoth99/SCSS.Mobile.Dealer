import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_model.dart';
import 'package:equatable/equatable.dart';

enum TransactionHistoryDetailProcess {
  neutral,
  processing,
  processed,
  error,
  valid,
  invalid,
}

abstract class TransactionHistoryDetailState extends Equatable {}

class NotLoadedState extends TransactionHistoryDetailState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends TransactionHistoryDetailState {
  final CDTransactionHistoryDetailModel model;
  final int grandTotal;

  LoadedState({required this.model, required this.grandTotal});

  @override
  List<Object> get props => [model, grandTotal];
}

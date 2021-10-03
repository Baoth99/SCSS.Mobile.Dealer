import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/utils/param_util.dart';

class CreateTransactionState {
  int dealerAccountId;
  int collectorAccountId;
  String transactionCode;
  int total;
  double awardPoint;
  DateTime createdTime;
  int bonusAmount;
  int createdBy;
  bool isDeleted;
  int? updatedBy;
  DateTime? updatedTime;
  List<CollectDealTransactionDetailModel> details;

  Process process;

  CreateTransactionState({
    int? dealerAccountId,
    int? collectorAccountId,
    String? transactionCode,
    int? total,
    double? awardPoint,
    DateTime? createdTime,
    int? bonusAmount,
    int? createdBy,
    bool? isDeleted,
    int? updatedBy,
    DateTime? updatedTime,
    List<CollectDealTransactionDetailModel>? details,
    Process? process,
  })  : dealerAccountId = dealerAccountId ?? 0,
        collectorAccountId = collectorAccountId ?? 0,
        transactionCode = transactionCode ?? '',
        total = total ?? 0,
        awardPoint = awardPoint ?? 0,
        createdTime = createdTime ?? DateTime.now(),
        bonusAmount = bonusAmount ?? 0,
        createdBy = createdBy ?? 0,
        isDeleted = isDeleted ?? false,
        updatedBy = updatedBy,
        updatedTime = updatedTime,
        details = details ?? [],
        process = process ?? Process.neutral;

  CreateTransactionState copyWith({
    int? dealerAccountId,
    int? collectorAccountId,
    String? transactionCode,
    int? total,
    double? awardPoint,
    DateTime? createdTime,
    int? bonusAmount,
    int? createdBy,
    bool? isDeleted,
    int? updatedBy,
    DateTime? updatedTime,
    List<CollectDealTransactionDetailModel>? details,
    Process? process,
  }) {
    return CreateTransactionState(
      dealerAccountId: dealerAccountId ?? this.dealerAccountId,
      collectorAccountId: collectorAccountId ?? this.collectorAccountId,
      transactionCode: transactionCode ?? this.transactionCode,
      total: total ?? this.total,
      awardPoint: awardPoint ?? this.awardPoint,
      createdTime: createdTime ?? this.createdTime,
      bonusAmount: bonusAmount ?? this.bonusAmount,
      createdBy: createdBy ?? this.createdBy,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedTime: updatedTime ?? this.updatedTime,
      details: details ?? this.details,
      process: process ?? this.process,
    );
  }
}

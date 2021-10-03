import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';

class CollectDealTransactionModel {
  int id;
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

  CollectDealTransactionModel({
    required this.id,
    required this.dealerAccountId,
    required this.collectorAccountId,
    required this.transactionCode,
    required this.total,
    required this.awardPoint,
    required this.createdTime,
    required this.bonusAmount,
    required this.createdBy,
    required this.isDeleted,
    this.updatedBy,
    this.updatedTime,
    required this.details,
  });

  List<CollectDealTransactionDetailModel> get getDetails => this.details;

  set setDetails(List<CollectDealTransactionDetailModel> details) =>
      this.details = details;

  int get getId => this.id;

  set setId(int id) => this.id = id;

  get getDealerAccountId => this.dealerAccountId;

  set setDealerAccountId(dealerAccountId) =>
      this.dealerAccountId = dealerAccountId;

  get getCollectorAccountId => this.collectorAccountId;

  set setCollectorAccountId(collectorAccountId) =>
      this.collectorAccountId = collectorAccountId;

  get getTransactionCode => this.transactionCode;

  set setTransactionCode(transactionCode) =>
      this.transactionCode = transactionCode;

  get getTotal => this.total;

  set setTotal(total) => this.total = total;

  get getAwardPoint => this.awardPoint;

  set setAwardPoint(awardPoint) => this.awardPoint = awardPoint;

  get getCreatedTime => this.createdTime;

  set setCreatedTime(createdTime) => this.createdTime = createdTime;

  get getBonusAmount => this.bonusAmount;

  set setBonusAmount(bonusAmount) => this.bonusAmount = bonusAmount;

  get getCreatedBy => this.createdBy;

  set setCreatedBy(createdBy) => this.createdBy = createdBy;

  get getIsDeleted => this.isDeleted;

  set setIsDeleted(isDeleted) => this.isDeleted = isDeleted;

  get getUpdatedBy => this.updatedBy;

  set setUpdatedBy(updatedBy) => this.updatedBy = updatedBy;

  get getUpdatedTime => this.updatedTime;

  set setUpdatedTime(updatedTime) => this.updatedTime = updatedTime;
}

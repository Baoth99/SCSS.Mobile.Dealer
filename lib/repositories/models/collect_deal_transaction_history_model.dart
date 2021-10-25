import 'collect_deal_transaction_history_detail_model.dart';

class CollectDealTransactionHistoryModel {
  CollectDealTransactionHistoryModel({
    required this.collectorName,
    required this.transactionCode,
    required this.transactionDate,
    required this.transactionTime,
    required this.total,
    required this.totalBonus,
    required this.transactionFee,
    required this.itemDetail,
  });

  String collectorName;
  String transactionCode;
  String transactionDate;
  String transactionTime;
  int total;
  int totalBonus;
  int transactionFee;
  List<CollectDealTransactionHistoryDetailModel> itemDetail;

  factory CollectDealTransactionHistoryModel.fromJson(
          Map<String, dynamic> json) =>
      CollectDealTransactionHistoryModel(
        collectorName:
            json["collectorName"] == null ? null : json["collectorName"],
        transactionCode:
            json["transactionCode"] == null ? null : json["transactionCode"],
        transactionDate:
            json["transactionDate"] == null ? null : json["transactionDate"],
        transactionTime:
            json["transactionTime"] == null ? null : json["transactionTime"],
        total: json["total"] == null ? null : json["total"],
        totalBonus: json["totalBonus"] == null ? null : json["totalBonus"],
        transactionFee:
            json["transactionFee"] == null ? null : json["transactionFee"],
        itemDetail: List<CollectDealTransactionHistoryDetailModel>.from(
            json["itemDetail"].map(
                (x) => CollectDealTransactionHistoryDetailModel.fromJson(x))),
      );
}

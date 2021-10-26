import 'package:intl/intl.dart';

import 'collect_deal_transaction_history_detail_item_model.dart';

class CDTransactionHistoryDetailModel {
  CDTransactionHistoryDetailModel({
    required this.collectorName,
    required this.transactionCode,
    required this.transactionDate,
    required this.transactionTime,
    required this.total,
    required this.totalBonus,
    required this.transactionFee,
    required this.itemDetails,
  });

  String collectorName;
  String transactionCode;
  DateTime transactionDate;
  String transactionTime;
  int total;
  int totalBonus;
  int transactionFee;
  List<CDTransactionHistoryDetailItemModel> itemDetails;

  factory CDTransactionHistoryDetailModel.fromJson(Map<String, dynamic> json) =>
      CDTransactionHistoryDetailModel(
        collectorName:
            json["collectorName"] == null ? null : json["collectorName"],
        transactionCode:
            json["transactionCode"] == null ? null : json["transactionCode"],
        transactionDate: DateFormat('dd-MM-yyy').parse(json["transactionDate"]),
        transactionTime:
            json["transactionTime"] == null ? null : json["transactionTime"],
        total: json["total"] == null ? null : json["total"],
        totalBonus: json["totalBonus"] == null ? null : json["totalBonus"],
        transactionFee:
            json["transactionFee"] == null ? null : json["transactionFee"],
        itemDetails: List<CDTransactionHistoryDetailItemModel>.from(
            json["itemDetail"]
                .map((x) => CDTransactionHistoryDetailItemModel.fromJson(x))),
      );
}

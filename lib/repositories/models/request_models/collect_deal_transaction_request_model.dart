import 'dart:convert';

import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';

String collectDealTransactionRequestModelToJson(
        CollectDealTransactionRequestModel data) =>
    json.encode(data);

class CollectDealTransactionRequestModel {
  CollectDealTransactionRequestModel({
    required this.collectorId,
    required this.transactionFee,
    required this.total,
    required this.totalBonus,
    required this.items,
  });

  String collectorId;
  int transactionFee;
  int total;
  int totalBonus;
  List<CollectDealTransactionDetailModel> items;

  Map<String, dynamic> toJson() => {
        "collectorId": collectorId == null ? null : collectorId,
        "transactionFee": transactionFee == null ? null : transactionFee,
        "total": total == null ? null : total,
        "totalBonus": totalBonus == null ? null : totalBonus,
        "items": items == null ? null : jsonEncode(items),
      };
}

import 'dart:convert';

import '../collect_deal_transaction_history_model.dart';

CollectDealTransactionDetailResponseModel
    collectDealTransactionDetailResponseModelFromJson(String str) =>
        CollectDealTransactionDetailResponseModel.fromJson(json.decode(str));

class CollectDealTransactionDetailResponseModel {
  CollectDealTransactionDetailResponseModel({
    required this.isSuccess,
    required this.statusCode,
    required this.msgCode,
    required this.msgDetail,
    required this.total,
    required this.resData,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  CollectDealTransactionHistoryModel resData;

  factory CollectDealTransactionDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CollectDealTransactionDetailResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: CollectDealTransactionHistoryModel.fromJson(json["resData"]),
      );
}

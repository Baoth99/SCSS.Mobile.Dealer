// To parse this JSON data, do
//
//     final dealerResponseModel = dealerResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:dealer_app/repositories/models/promotion_model.dart';

PromotionResponseModel dealerResponseModelFromJson(String str) =>
    PromotionResponseModel.fromJson(json.decode(str));

String dealerResponseModelToJson(PromotionResponseModel data) =>
    json.encode(data.toJson());

class PromotionResponseModel {
  PromotionResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.promotionModels,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  List<PromotionModel>? promotionModels;

  factory PromotionResponseModel.fromJson(Map<String, dynamic> json) =>
      PromotionResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        promotionModels: json["resData"] == null
            ? null
            : List<PromotionModel>.from(
                json["resData"].map((x) => PromotionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": promotionModels == null
            ? null
            : List<dynamic>.from(promotionModels!.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final promotionModel = promotionModelFromJson(jsonString);

import 'dart:convert';

PromotionModel promotionModelFromJson(String str) =>
    PromotionModel.fromJson(json.decode(str));

String promotionModelToJson(PromotionModel data) => json.encode(data.toJson());

class PromotionModel {
  PromotionModel({
    required this.id,
    required this.code,
    required this.promotionName,
    required this.appliedScrapCategory,
    required this.appliedScrapCategoryImageUrl,
    this.appliedAmount,
    this.bonusAmount,
    required this.appliedFromTime,
    required this.appliedToTime,
    this.status,
  });

  String id;
  String code;
  String promotionName;
  String appliedScrapCategory;
  String appliedScrapCategoryImageUrl;
  int? appliedAmount;
  int? bonusAmount;
  DateTime appliedFromTime;
  DateTime appliedToTime;
  int? status;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        id: json["id"],
        code: json["code"],
        promotionName: json["promotionName"],
        appliedScrapCategory: json["appliedScrapCategory"],
        appliedScrapCategoryImageUrl: json["appliedScrapCategoryImageUrl"],
        appliedAmount: json["appliedAmount"],
        bonusAmount: json["bonusAmount"],
        appliedFromTime: DateTime.parse(json["appliedFromTime"]),
        appliedToTime: DateTime.parse(json["appliedToTime"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "promotionName": promotionName,
        "appliedScrapCategory": appliedScrapCategory,
        "appliedScrapCategoryImageUrl": appliedScrapCategoryImageUrl,
        "appliedAmount": appliedAmount.toString(),
        "bonusAmount": bonusAmount.toString(),
        "appliedFromTime": appliedFromTime.toString(),
        "appliedToTime": appliedToTime.toString(),
        "status": status.toString(),
      };
}

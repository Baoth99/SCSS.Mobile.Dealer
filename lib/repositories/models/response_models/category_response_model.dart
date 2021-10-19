// To parse this JSON data, do
//
//     final dealerResponseModel = dealerResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:dealer_app/repositories/models/scrap_category_model.dart';

ScrapCategoryResponseModel dealerResponseModelFromJson(String str) =>
    ScrapCategoryResponseModel.fromJson(json.decode(str));

String dealerResponseModelToJson(ScrapCategoryResponseModel data) =>
    json.encode(data.toJson());

class ScrapCategoryResponseModel {
  ScrapCategoryResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.scrapCategoryModels,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  List<ScrapCategoryModel>? scrapCategoryModels;

  factory ScrapCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      ScrapCategoryResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        scrapCategoryModels: json["resData"] == null
            ? null
            : List<ScrapCategoryModel>.from(
                json["resData"].map((x) => ScrapCategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": scrapCategoryModels == null
            ? null
            : List<dynamic>.from(scrapCategoryModels!.map((x) => x.toJson())),
      };
}

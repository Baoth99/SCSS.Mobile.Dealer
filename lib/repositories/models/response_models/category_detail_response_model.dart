// To parse this JSON data, do
//
//     final dealerResponseModel = dealerResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';

ScrapCategoryDetailResponseModel dealerResponseModelFromJson(String str) =>
    ScrapCategoryDetailResponseModel.fromJson(json.decode(str));

String dealerResponseModelToJson(ScrapCategoryDetailResponseModel data) =>
    json.encode(data.toJson());

class ScrapCategoryDetailResponseModel {
  ScrapCategoryDetailResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.scrapCategoryDetailModels,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  List<ScrapCategoryDetailModel>? scrapCategoryDetailModels;

  factory ScrapCategoryDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ScrapCategoryDetailResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        scrapCategoryDetailModels: json["resData"] == null
            ? null
            : List<ScrapCategoryDetailModel>.from(json["resData"]
                .map((x) => ScrapCategoryDetailModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": scrapCategoryDetailModels == null
            ? null
            : List<dynamic>.from(
                scrapCategoryDetailModels!.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final scrapCategoryModel = scrapCategoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';

ScrapCategoryModel scrapCategoryModelFromJson(String str) =>
    ScrapCategoryModel.fromJson(json.decode(str));

String scrapCategoryModelToJson(ScrapCategoryModel data) =>
    json.encode(data.toJson());

class ScrapCategoryModel {
  ScrapCategoryModel({
    required this.id,
    required this.name,
    this.promotionId,
    this.promotionCode,
    required this.appliedAmount,
    required this.bonusAmount,
  });

  String id;
  String name;
  dynamic promotionId;
  dynamic promotionCode;
  dynamic appliedAmount;
  dynamic bonusAmount;

  factory ScrapCategoryModel.fromJson(Map<String, dynamic> json) =>
      ScrapCategoryModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        promotionId: json["promotionId"],
        promotionCode: json["promotionCode"],
        appliedAmount: json["appliedAmount"],
        bonusAmount: json["bonusAmount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "promotionId": promotionId,
        "promotionCode": promotionCode,
        "appliedAmount": appliedAmount,
        "bonusAmount": bonusAmount,
      };
}

class ScrapCategoryModelTemp extends Comparable<ScrapCategoryModelTemp> {
  int id;
  String name;
  String? imageUrl;
  int accountId;
  int createdBy;
  DateTime createdTime;
  int status;
  int updatedBy;
  DateTime updatedTime;
  List<ScrapCategoryDetailModelTemp>? unitList;

  ScrapCategoryModelTemp({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.accountId,
    required this.createdBy,
    required this.createdTime,
    required this.status,
    required this.updatedBy,
    required this.updatedTime,
    this.unitList,
  });

  get getId => this.id;

  set setId(id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getImageUrl => this.imageUrl;

  set setImageUrl(imageUrl) => this.imageUrl = imageUrl;

  get getAccountId => this.accountId;

  set setAccountId(accountId) => this.accountId = accountId;

  get getCreatedBy => this.createdBy;

  set setCreatedBy(createdBy) => this.createdBy = createdBy;

  get getCreatedTime => this.createdTime;

  set setCreatedTime(createdTime) => this.createdTime = createdTime;

  get getStatus => this.status;

  set setStatus(status) => this.status = status;

  get getUpdatedBy => this.updatedBy;

  set setUpdatedBy(updatedBy) => this.updatedBy = updatedBy;

  get getUpdatedTime => this.updatedTime;

  set setUpdatedTime(updatedTime) => this.updatedTime = updatedTime;

  get getUnitList => this.unitList;

  set setUnitList(unitList) => this.unitList = unitList;

  @override
  int compareTo(ScrapCategoryModelTemp other) {
    return this.name.compareTo(other.name);
  }
}

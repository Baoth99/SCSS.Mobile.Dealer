// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:dealer_app/utils/param_util.dart';
import 'package:intl/intl.dart';

UserInfoModel userProfileModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userProfileModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
    required this.sub,
    required this.address,
    required this.role,
    required this.gender,
    required this.birthdate,
    required this.name,
    this.picture,
    required this.id,
    required this.preferredUsername,
    this.email,
    required this.emailVerified,
    required this.phoneNumber,
    required this.phoneNumberVerified,
  });

  String sub;
  String address;
  String role;
  int gender;
  DateTime birthdate;
  String name;
  String? picture;
  String id;
  String preferredUsername;
  String? email;
  bool emailVerified;
  String phoneNumber;
  bool phoneNumberVerified;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        sub: json["sub"],
        address: json["address"],
        role: json["role"],
        gender: int.parse(json["gender"]),
        birthdate: DateFormat(CustomFormats.birthday).parse(json["birthdate"]),
        name: json["name"],
        picture: json["picture"] == 'N/A' ? null : json["picture"],
        id: json["id"],
        preferredUsername: json["preferred_username"],
        email: json["email"] == 'N/A' ? null : json["email"],
        emailVerified: json["email_verified"],
        phoneNumber: json["phone_number"],
        phoneNumberVerified: json["phone_number_verified"],
      );

  Map<String, dynamic> toJson() => {
        "sub": sub,
        "address": address,
        "role": role,
        "gender": gender,
        "birthdate": birthdate,
        "name": name,
        "picture": picture == null ? null : picture,
        "id": id,
        "preferred_username": preferredUsername,
        "email": email == null ? null : email,
        "email_verified": emailVerified,
        "phone_number": phoneNumber,
        "phone_number_verified": phoneNumberVerified,
      };
}

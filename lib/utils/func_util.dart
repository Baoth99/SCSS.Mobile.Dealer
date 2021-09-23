import 'dart:convert';
import 'package:dealer_app/repositories/models/user_profile_model.dart';
import 'package:http/http.dart' as http;

import 'package:dealer_app/repositories/models/access_token_holder_model.dart';
import 'package:dealer_app/utils/env_util.dart';

class APICaller {
  Future<AccessTokenHolderModel> fectchAccessToken(
      {required String phone, required String password}) async {
    String scope = EnvID4AppSettingValue.scopeRole +
        ' ' +
        EnvID4AppSettingValue.scopeIdCard +
        ' ' +
        EnvID4AppSettingValue.scopeOfflineAccess +
        ' ' +
        EnvID4AppSettingValue.scopeOpenId +
        ' ' +
        EnvID4AppSettingValue.scopePhone +
        ' ' +
        EnvID4AppSettingValue.scopeProfile +
        ' ' +
        EnvID4AppSettingValue.scopeResource +
        ' ' +
        EnvID4AppSettingValue.scopeEmail;
    Map<String, dynamic> body = {
      'client_id': EnvID4AppSettingValue.clientId,
      'client_secret': EnvID4AppSettingValue.clientSecret,
      'grant_type': EnvID4AppSettingValue.grantTypePassword,
      'username': phone,
      'password': password,
      'scope': scope
    };
    final response = await http.post(
        Uri.parse(EnvID4AppSettingValue.apiUrl + 'connect/token'),
        body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AccessTokenHolderModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Login failed');
    } else {
      throw Exception('Failed to fetch token');
    }
  }

  Future<UserInfoModel> fectchUserInfo({required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    final response = await http.get(
        Uri.parse(EnvID4AppSettingValue.apiUrl + 'connect/userinfo'),
        headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return UserInfoModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch user info');
    }
  }
}

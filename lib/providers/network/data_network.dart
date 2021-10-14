import 'dart:convert';
import 'dart:io';

import 'package:dealer_app/repositories/models/response_models/category_detail_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/category_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class DataNetWork {
  static Future<ScrapCategoryResponseModel> getScrapCategories(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomTexts.apiUrlGetScrapCategories);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScrapCategoryResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.getScrapCategoriesFailedException);
    }
  }

  static Future<ScrapCategoryDetailResponseModel> getScrapCategoryDetails({
    required String bearerToken,
    required String scrapCategoryId,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, String> queryParams = {
      'id': scrapCategoryId,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomTexts.apiUrlGetScrapCategoryDetails, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScrapCategoryDetailResponseModel.fromJson(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.getScrapCategoryDetailsFailedException);
    }
  }
}

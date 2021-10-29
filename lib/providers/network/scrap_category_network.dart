import 'dart:io';

import 'package:dealer_app/repositories/models/response_models/category_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class ScrapCategoryNetWork {
  static Future<ScrapCategoryResponseModel> getScrapCategories({
    required String bearerToken,
    String? page,
    String? pageSize,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {};
    if (page != null) queryParams.putIfAbsent('Page', () => page);
    if (pageSize != null) queryParams.putIfAbsent('PageSize', () => pageSize);

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomTexts.apiUrlGetScrapCategoriesFromScrapCategory, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return responseModelFromJsonToCategoryListModel(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.getScrapCategoriesFailedException);
    }
  }
}

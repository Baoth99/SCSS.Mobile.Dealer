import 'dart:io';

import 'package:dealer_app/repositories/models/response_models/get_promotion_detail_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/get_promotion_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class PromotionNetwork {
  static Future<GetPromotionResponseModel> getPromotion(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };
    final uri =
        Uri.http(EnvAppApiSettingValue.apiUrl, CustomTexts.apiUrlGetPromotions);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getPromotionResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.getPromotionsFailedException);
    }
  }

  static Future<GetPromotionDetailResponseModel> getPromotionDetail({
    required String bearerToken,
    required String id,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {
      'id': id,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomTexts.apiUrlGetScrapCategorDetailFromScrapCategory, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getPromotionDetailResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.getScrapCategoryDetailsFailedException);
    }
  }
}

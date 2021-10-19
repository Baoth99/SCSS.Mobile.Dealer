import 'dart:convert';
import 'dart:io';

import 'package:dealer_app/repositories/models/request_models/collect_deal_transaction_request_model.dart';
import 'package:dealer_app/repositories/models/response_models/info_review_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class CollectDealTransactionNetWork {
  static Future<InfoReviewResponseModel> getInfoReview({
    required String bearerToken,
    required String collectorId,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, String> queryParams = {
      'collectorId': collectorId,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomTexts.apiUrlGetInfoReview, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return InfoReviewResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.getInfoReviewFailedException);
    }
  }

  static Future<bool> postCollectDealTransaction({
    required String bearerToken,
    required String body,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomTexts.apiUrlPostCollectDealTransaction);

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.postCollectDealTransactionFailedException);
    }
  }
}

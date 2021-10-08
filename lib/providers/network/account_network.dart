import 'dart:convert';

import 'package:dealer_app/repositories/models/response_models/dealer_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class AccountNetwork {
  static Future<DealerResponseModel> fectchDealerInfo(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    final response = await http.get(
        Uri.parse(
            EnvAppApiSettingValue.apiUrl + CustomTexts.apiUrlDealerInfoLink),
        headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return DealerResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomTexts.fetchDealerInfoFailedException);
    }
  }

  static Future<bool> putDeviceId(
      {required String bearerToken, required String deivceId}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $bearerToken',
    };
    var body = jsonEncode(<String, String>{
      'deviceId': deivceId,
    });

    final response = await http.put(
        Uri.parse(EnvAppApiSettingValue.apiUrl + CustomTexts.apiUrlPutDeviceId),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(CustomTexts.putDeviceIdFailedException);
    }
  }
}

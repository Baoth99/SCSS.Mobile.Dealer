import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/profile_info_response_model.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';

abstract class IdentityServerNetwork {
  Future<ProfileInfoResponseModel> getAccountInfo(Client client);

  Future<int?> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
    Client client,
  );
}

class IdentityServerNetworkImpl implements IdentityServerNetwork {
  @override
  Future<ProfileInfoResponseModel> getAccountInfo(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.accountCollectorInfo,
      client: client,
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<ProfileInfoResponseModel>(
      response,
      profileInfoResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<int?> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
    Client client,
  ) async {
    var body = <String, String>{
      'Id': id,
      'OldPassword': oldPassword,
      'NewPassword': newPassword,
    };
    //send request
    var response = await NetworkUtils.postBody(
      uri: IdentityAPIConstants.urlChangePassword,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: body,
      client: client,
    );

    // convert
    // ignore: prefer_typing_uninitialized_variables
    BaseResponseModel responseModel;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = BaseResponseModel.fromJson(
        await NetworkUtils.getMapFromResponse(response),
      );
      if (responseModel.isSuccess) {
        return NetworkConstants.ok200;
      } else {
        return NetworkConstants.badRequest400;
      }
    }

    return null;
  }
}

import 'package:dealer_app/repositories/models/response_models/profile_info_response_model.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';

abstract class IdentityServerNetwork {
  Future<ProfileInfoResponseModel> getAccountInfo(Client client);
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
}

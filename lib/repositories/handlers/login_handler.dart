import 'package:dealer_app/providers/network/login_network.dart';
import 'package:dealer_app/repositories/models/access_token_holder_model.dart';
import 'package:dealer_app/repositories/models/user_profile_model.dart';

abstract class ILoginHandler {
  Future<UserInfoModel> login(
      {required String phone, required String password});
}

class LoginHandler implements ILoginHandler {
  Future<UserInfoModel> login(
      {required String phone, required String password}) async {
    //get access token
    AccessTokenHolderModel accessTokenHolderModel =
        await LoginNetwork.fectchAccessToken(phone: phone, password: password);
    //get user information
    return await LoginNetwork.fectchUserInfo(
        bearerToken: accessTokenHolderModel.accessToken);
  }
}

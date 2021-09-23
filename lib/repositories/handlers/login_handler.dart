import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/login_network.dart';
import 'package:dealer_app/repositories/models/access_token_holder_model.dart';
import 'package:dealer_app/repositories/models/user_profile_model.dart';

class LoginHandler {
  final _loginNetwork = getIt.get<LoginNetwork>();
  Future<UserInfoModel> login(
      {required String phone, required String password}) async {
    //get access token
    AccessTokenHolderModel accessTokenHolderModel =
        await _loginNetwork.fectchAccessToken(phone: phone, password: password);
    //get user information
    return await _loginNetwork.fectchUserInfo(
        bearerToken: accessTokenHolderModel.accessToken);
  }
}

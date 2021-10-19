import 'package:dealer_app/providers/network/account_network.dart';
import 'package:dealer_app/providers/network/login_network.dart';
import 'package:dealer_app/repositories/models/access_token_holder_model.dart';

import 'dart:async';

import 'package:dealer_app/utils/device_info.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class IAuthenticationHandler {
  Stream<AuthenticationStatus> get stream;
  Future<void> login({required String phone, required String password});
  void logout();
  void dispose();
}

class AuthenticationHandler implements IAuthenticationHandler {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get stream async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      //get device ID
      var _deviceId = await DeviceInfo.getDeviceId();
      //get access token
      AccessTokenHolderModel accessTokenHolderModel =
          await LoginNetwork.fectchAccessToken(
              phone: phone, password: password);
      //save token
      bool result = await SecureStorage.writeValue(
          key: CustomKeys.accessToken,
          value: accessTokenHolderModel.accessToken);
      if (result) {
        //put device Id
        if (_deviceId != null) {
          await AccountNetwork.putDeviceId(
              bearerToken: accessTokenHolderModel.accessToken,
              deivceId: _deviceId);
        }
        //add event
        _controller.add(AuthenticationStatus.authenticated);
      } else
        _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw (e);
    }
  }

  void logout() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

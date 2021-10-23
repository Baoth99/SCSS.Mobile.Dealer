import 'package:dealer_app/providers/network/account_network.dart';
import 'package:dealer_app/repositories/models/response_models/dealer_response_model.dart';
import 'package:dealer_app/utils/device_info.dart';

abstract class IUserHandler {
  Future<DealerResponseModel?> getUser({required String bearerToken});
  Future<bool> putDeviceIdWhenLogin({required String bearerToken});
}

class UserHandler implements IUserHandler {
  DealerResponseModel? _responseModel;

  Future<DealerResponseModel?> getUser({required String bearerToken}) async {
    if (_responseModel != null)
      return _responseModel;
    else
      _responseModel =
          await AccountNetwork.getDealerInfo(bearerToken: bearerToken);
    return _responseModel;
  }

  Future<bool> putDeviceIdWhenLogin({required String bearerToken}) async {
    //Get Device Id
    var _deviceId = await DeviceInfo.getDeviceId();
    if (_deviceId != null) {
      return await AccountNetwork.putDeviceId(
          bearerToken: bearerToken, deivceId: _deviceId);
    } else
      return false;
  }
}

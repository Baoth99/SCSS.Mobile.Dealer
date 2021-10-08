import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId;
  }
}

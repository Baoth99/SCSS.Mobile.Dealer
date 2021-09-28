import 'package:dealer_app/utils/param_util.dart';

class RegisterOTPState {
  String phone;
  String otp;

  bool get isOTPValid => RegExp(CustomRegexs.otpRegex).hasMatch(otp);

  Process process;

  RegisterOTPState({
    required phone,
    otp,
    process,
  })  : phone = phone,
        otp = otp ?? '',
        process = process ?? Process.neutral;

  RegisterOTPState copyWith({
    String? phone,
    String? otp,
    Process? process,
  }) {
    return RegisterOTPState(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      process: process ?? this.process,
    );
  }
}

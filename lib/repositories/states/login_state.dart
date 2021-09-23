enum Process { notSubmitted, processing, finishProcessing, invalid, validated }

class LoginState {
  String phone;
  String password;

  Process process;

  bool? get isPhoneValid => phone.length != 10;

  LoginState({String? phone, String? password, Process? process})
      : phone = phone ?? '',
        password = password ?? '',
        process = process ?? Process.notSubmitted;

  LoginState copyWith({String? phone, String? password, Process? process}) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      process: process ?? this.process,
    );
  }
}

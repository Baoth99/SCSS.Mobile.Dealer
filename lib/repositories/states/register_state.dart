import 'package:dealer_app/utils/param_util.dart';

class RegisterState {
  String phone;
  // String name, id;
  // DateTime? birthdate;
  // String address;
  // Sex sex;
  // String password, rePassword;
  // bool isBranch;
  // int? mainBranchId;
  // String storeName, storePhone, storeAddress;

  Process process;

  bool get isPhoneValid => RegExp(CustomRegexs.phoneRegex).hasMatch(phone);

  RegisterState({
    phone,
    // name,
    // id,
    // birthdate,
    // address,
    // sex,
    // password,
    // rePassword,
    // isBranch,
    // mainBranchId,
    // storeName,
    // storePhone,
    // storeAddress,
    process,
  })  : phone = phone ?? '',
        // name = name ?? '',
        // id = id ?? '',
        // birthdate = birthdate,
        // address = address ?? '',
        // sex = sex ?? Sex.male,
        // password = password ?? '',
        // rePassword = rePassword ?? '',
        // isBranch = isBranch ?? false,
        // mainBranchId = mainBranchId,
        // storeName = storeName ?? '',
        // storePhone = storePhone ?? '',
        // storeAddress = storeAddress ?? '',
        process = process ?? Process.neutral;

  RegisterState copyWith({
    String? phone,
    // String? name,
    // String? id,
    // DateTime? birthdate,
    // String? address,
    // Sex? sex,
    // String? password,
    // String? rePassword,
    // bool? isBranch,
    // int? mainBranchId,
    // String? storeName,
    // String? storePhone,
    // String? storeAddress,
    Process? process,
  }) {
    return RegisterState(
      phone: phone ?? this.phone,
      // name: name ?? this.name,
      // id: id ?? this.id,
      // birthdate: birthdate ?? this.birthdate,
      // address: address ?? this.address,
      // sex: sex ?? this.sex,
      // password: password ?? this.password,
      // rePassword: rePassword ?? this.rePassword,
      // isBranch: isBranch ?? this.isBranch,
      // mainBranchId: mainBranchId ?? this.mainBranchId,
      // storeName: storeName ?? this.storeName,
      // storePhone: storePhone ?? this.storePhone,
      // storeAddress: storeAddress ?? this.storeAddress,
      process: process ?? this.process,
    );
  }
}

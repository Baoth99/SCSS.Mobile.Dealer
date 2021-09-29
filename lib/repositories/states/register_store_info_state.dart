import 'package:dealer_app/utils/param_util.dart';

class RegisterStoreInfoState {
  String phone;
  String name;
  String id;
  DateTime? birthdate;
  String address;
  Sex sex;
  String password;
  String rePassword;
  bool isBranch;
  int? mainBranchId;

  String pickedImageUrl;
  String storeName;
  String storePhone;
  String storeAddress;

  bool isImageSourceActionSheetVisible;
  Process process;

  bool get isImagePicked => pickedImageUrl != '';
  bool get isStorePhoneValid =>
      RegExp(CustomRegexs.phoneRegex).hasMatch(storePhone);

  RegisterStoreInfoState({
    String? phone,
    String? name,
    String? id,
    DateTime? birthdate,
    String? address,
    Sex? sex,
    String? password,
    String? rePassword,
    Process? process,
    bool? isBranch,
    int? mainBranchId,
    String? pickedImageUrl,
    String? storeName,
    String? storePhone,
    String? storeAddress,
    bool? isImageSourceActionSheetVisible,
  })  : phone = phone ?? '',
        name = name ?? '',
        id = id ?? '',
        birthdate = birthdate,
        address = address ?? '',
        sex = sex ?? Sex.male,
        password = password ?? '',
        rePassword = rePassword ?? '',
        process = process ?? Process.neutral,
        isBranch = isBranch ?? false,
        mainBranchId = mainBranchId,
        pickedImageUrl = pickedImageUrl ?? '',
        storeName = storeName ?? '',
        storePhone = storePhone ?? '',
        storeAddress = storeAddress ?? '',
        isImageSourceActionSheetVisible =
            isImageSourceActionSheetVisible ?? false;

  RegisterStoreInfoState copyWith({
    String? phone,
    String? name,
    String? id,
    DateTime? birthdate,
    String? address,
    Sex? sex,
    String? password,
    String? rePassword,
    Process? process,
    bool? isBranch,
    int? mainBranchId,
    String? pickedImageUrl,
    String? storeName,
    String? storePhone,
    String? storeAddress,
    bool? isImageSourceActionSheetVisible,
  }) {
    return RegisterStoreInfoState(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      id: id ?? this.id,
      birthdate: birthdate ?? this.birthdate,
      address: address ?? this.address,
      sex: sex ?? this.sex,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      process: process ?? this.process,
      isBranch: isBranch ?? this.isBranch,
      mainBranchId: mainBranchId ?? this.mainBranchId,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      storeName: storeName ?? this.storeName,
      storePhone: storePhone ?? this.storePhone,
      storeAddress: storeAddress ?? this.storeAddress,
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
    );
  }
}

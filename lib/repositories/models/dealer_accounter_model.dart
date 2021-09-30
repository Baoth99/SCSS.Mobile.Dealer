enum Sex {
  male,
  female,
}

class DealerAccountModel {
  String phone;
  String name, id;
  DateTime? birthdate;
  String address;
  Sex sex;
  String password, rePassword;
  bool isBranch;
  int? mainBranchId;
  String storeName, storePhone, storeAddress;

  DealerAccountModel(
      {phone,
      name,
      id,
      birthdate,
      address,
      sex,
      password,
      rePassword,
      isBranch,
      mainBranchId,
      storeName,
      storePhone,
      storeAddress})
      : phone = phone ?? '',
        name = name ?? '',
        id = id ?? '',
        birthdate = birthdate,
        address = address ?? '',
        sex = sex ?? Sex.male,
        password = password ?? '',
        rePassword = rePassword ?? '',
        isBranch = isBranch ?? false,
        mainBranchId = mainBranchId,
        storeName = storeName ?? '',
        storePhone = storePhone ?? '',
        storeAddress = storeAddress ?? '';

  String get getPhone => this.phone;

  set setPhone(String phone) => this.phone = phone;

  get getId => this.id;

  set setId(id) => this.id = id;

  get getBirthdate => this.birthdate;

  set setBirthdate(birthdate) => this.birthdate = birthdate;

  get getAddress => this.address;

  set setAddress(address) => this.address = address;

  get getSex => this.sex;

  set setSex(sex) => this.sex = sex;

  get getRePassword => this.rePassword;

  set setRePassword(rePassword) => this.rePassword = rePassword;

  get getIsBranch => this.isBranch;

  set setIsBranch(isBranch) => this.isBranch = isBranch;

  get getMainBranchId => this.mainBranchId;

  set setMainBranchId(mainBranchId) => this.mainBranchId = mainBranchId;

  get getStoreAddress => this.storeAddress;

  set setStoreAddress(storeAddress) => this.storeAddress = storeAddress;
}

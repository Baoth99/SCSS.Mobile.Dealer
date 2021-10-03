class PromotionModel {
  int id;
  String name;
  int dealerCategoryId;
  int dealerAccountId;
  String code;
  int appliedAmount;
  int bonusAmount;
  DateTime fromTime;
  DateTime toTime;
  int status;
  int createdBy;
  DateTime createdTime;
  bool isDeleted;
  int? updatedBy;
  DateTime? updatedTime;

  PromotionModel({
    required this.id,
    required this.name,
    required this.dealerCategoryId,
    required this.dealerAccountId,
    required this.code,
    required this.appliedAmount,
    required this.bonusAmount,
    required this.fromTime,
    required this.toTime,
    required this.status,
    required this.createdBy,
    required this.createdTime,
    required this.isDeleted,
    this.updatedBy,
    this.updatedTime,
  });

  get getId => this.id;

  set setId(id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getDealerCategoryId => this.dealerCategoryId;

  set setDealerCategoryId(dealerCategoryId) =>
      this.dealerCategoryId = dealerCategoryId;

  get getDealerAccountId => this.dealerAccountId;

  set setDealerAccountId(dealerAccountId) =>
      this.dealerAccountId = dealerAccountId;

  get getCode => this.code;

  set setCode(code) => this.code = code;

  get getAppliedAmount => this.appliedAmount;

  set setAppliedAmount(appliedAmount) => this.appliedAmount = appliedAmount;

  get getBonusAmount => this.bonusAmount;

  set setBonusAmount(bonusAmount) => this.bonusAmount = bonusAmount;

  get getFromTime => this.fromTime;

  set setFromTime(fromTime) => this.fromTime = fromTime;

  get getToTime => this.toTime;

  set setToTime(toTime) => this.toTime = toTime;

  get getStatus => this.status;

  set setStatus(status) => this.status = status;

  get getCreatedBy => this.createdBy;

  set setCreatedBy(createdBy) => this.createdBy = createdBy;

  get getCreatedTime => this.createdTime;

  set setCreatedTime(createdTime) => this.createdTime = createdTime;

  get getIsDeleted => this.isDeleted;

  set setIsDeleted(isDeleted) => this.isDeleted = isDeleted;

  get getUpdatedBy => this.updatedBy;

  set setUpdatedBy(updatedBy) => this.updatedBy = updatedBy;

  get getUpdatedTime => this.updatedTime;

  set setUpdatedTime(updatedTime) => this.updatedTime = updatedTime;
}

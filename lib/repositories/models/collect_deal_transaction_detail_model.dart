class CollectDealTransactionDetailModel {
  int id;
  int collectDealTransactionId;
  int dealerCategoryDetailId;
  int price;
  int quantity;
  int total;
  int bonusAmount;
  int? promotionId;
  int createdBy;
  DateTime createdTime;
  bool isDeleted;
  int? updatedBy;
  DateTime? updatedTime;

  CollectDealTransactionDetailModel({
    required this.id,
    required this.collectDealTransactionId,
    required this.dealerCategoryDetailId,
    required this.price,
    required this.quantity,
    required this.total,
    required this.bonusAmount,
    required this.createdBy,
    required this.createdTime,
    required this.isDeleted,
    this.updatedBy,
    this.updatedTime,
    this.promotionId,
  });

  get getId => this.id;

  set setId(id) => this.id = id;

  get getCollectDealTransactionId => this.collectDealTransactionId;

  set setCollectDealTransactionId(collectDealTransactionId) =>
      this.collectDealTransactionId = collectDealTransactionId;

  get getDealerCategoryDetailId => this.dealerCategoryDetailId;

  set setDealerCategoryDetailId(dealerCategoryDetailId) =>
      this.dealerCategoryDetailId = dealerCategoryDetailId;

  get getPrice => this.price;

  set setPrice(price) => this.price = price;

  get getQuantity => this.quantity;

  set setQuantity(quantity) => this.quantity = quantity;

  get getTotal => this.total;

  set setTotal(total) => this.total = total;

  get getBonusAmount => this.bonusAmount;

  set setBonusAmount(bonusAmount) => this.bonusAmount = bonusAmount;

  get getPromotionId => this.promotionId;

  set setPromotionId(promotionId) => this.promotionId = promotionId;

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

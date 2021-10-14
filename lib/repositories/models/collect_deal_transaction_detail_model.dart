class CollectDealTransactionDetailModel {
  String dealerCategoryId;
  String dealerCategoryDetailId;
  int quantity;
  String promotionId;
  int bonusAmount;
  int total;
  int price;

  bool isCalculatedByUnitPrice;

  int get totalCalculated {
    if (isCalculatedByUnitPrice && price != 0)
      return price * quantity;
    else
      return 0;
  }

  CollectDealTransactionDetailModel({
    required this.dealerCategoryId,
    required this.dealerCategoryDetailId,
    required this.quantity,
    required this.promotionId,
    required this.bonusAmount,
    required this.total,
    required this.price,
    required this.isCalculatedByUnitPrice,
  });

  String get getDealerCategoryId => this.dealerCategoryId;

  set setDealerCategoryId(String dealerCategoryId) =>
      this.dealerCategoryId = dealerCategoryId;

  String get getDealerCategoryDetailId => this.dealerCategoryDetailId;

  set setDealerCategoryDetailId(String dealerCategoryDetailId) =>
      this.dealerCategoryDetailId = dealerCategoryDetailId;

  get getQuantity => this.quantity;

  set setQuantity(quantity) => this.quantity = quantity;

  get getPromotionId => this.promotionId;

  set setPromotionId(promotionId) => this.promotionId = promotionId;

  get getBonusAmount => this.bonusAmount;

  set setBonusAmount(bonusAmount) => this.bonusAmount = bonusAmount;

  get getTotal => this.total;

  set setTotal(total) => this.total = total;

  get getPrice => this.price;

  set setPrice(price) => this.price = price;

  get getIsCalculatedByUnitPrice => this.isCalculatedByUnitPrice;

  set setIsCalculatedByUnitPrice(isCalculatedByUnitPrice) =>
      this.isCalculatedByUnitPrice = isCalculatedByUnitPrice;
}

class CollectDealTransactionDetailModel {
  String dealerCategoryId;
  String? dealerCategoryDetailId;
  int quantity;
  String? unit;
  String? promotionId;
  int bonusAmount;
  int total;
  int price;

  bool isCalculatedByUnitPrice;
  bool isPromotionnApplied;

  int get totalCalculated {
    if (isCalculatedByUnitPrice && price != 0)
      return price * quantity;
    else
      return 0;
  }

  CollectDealTransactionDetailModel({
    required this.dealerCategoryId,
    this.dealerCategoryDetailId,
    required this.quantity,
    this.unit,
    this.promotionId,
    required this.bonusAmount,
    required this.total,
    required this.price,
    required this.isCalculatedByUnitPrice,
    this.isPromotionnApplied = false,
  });
}

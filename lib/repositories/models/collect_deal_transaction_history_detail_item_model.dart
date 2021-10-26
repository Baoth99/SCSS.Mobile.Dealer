class CDTransactionHistoryDetailItemModel {
  CDTransactionHistoryDetailItemModel({
    required this.scrapCategoryName,
    required this.quantity,
    required this.total,
    required this.isBonus,
    required this.bonusAmount,
  });

  String? scrapCategoryName;
  int quantity;
  int total;
  bool isBonus;
  int bonusAmount;

  factory CDTransactionHistoryDetailItemModel.fromJson(
          Map<String, dynamic> json) =>
      CDTransactionHistoryDetailItemModel(
        scrapCategoryName: json["scrapCategoryName"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        total: json["total"] == null ? null : json["total"],
        isBonus: json["isBonus"] == null ? null : json["isBonus"],
        bonusAmount: json["bonusAmount"] == null ? null : json["bonusAmount"],
      );
}

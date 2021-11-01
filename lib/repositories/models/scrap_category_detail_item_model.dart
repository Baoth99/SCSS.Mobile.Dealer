class CategoryDetailItemModel {
  CategoryDetailItemModel({
    required this.id,
    required this.unit,
    required this.price,
    required this.status,
  });

  String id;
  String unit;
  int price;
  int status;

  factory CategoryDetailItemModel.fromJson(Map<String, dynamic> json) =>
      CategoryDetailItemModel(
        id: json["id"] == null ? null : json["id"],
        unit: json["unit"] == null ? null : json["unit"],
        price: json["price"] == null ? null : json["price"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit": unit,
        "price": price,
        "status": status,
      };
}

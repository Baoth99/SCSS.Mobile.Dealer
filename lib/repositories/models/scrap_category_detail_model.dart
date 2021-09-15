class ScrapCategoryDetailModel {
  int id;
  String unit;
  int? price;
  int? status;

  int get getId => this.id;

  set setId(int id) => this.id = id;

  String get getUnit => this.unit;

  set setUnit(unit) => this.unit = unit;

  int? get getPrice => this.price;

  set setPrice(price) => this.price = price;

  int? get getStatus => this.status;

  set setStatus(status) => this.status = status;

  ScrapCategoryDetailModel.withPrice(
      this.id, this.unit, this.price, this.status);
  ScrapCategoryDetailModel.withoutPrice(this.id, this.unit, this.status);
}

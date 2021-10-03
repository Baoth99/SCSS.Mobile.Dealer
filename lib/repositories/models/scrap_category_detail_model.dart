class ScrapCategoryDetailModel {
  int id;
  int scrapCategoryId;
  String unit;
  int? price;
  int createdBy;
  DateTime createdTime;
  int status;
  int updatedBy;
  DateTime updatedTime;

  ScrapCategoryDetailModel({
    required int id,
    required int scrapCategoryId,
    required String unit,
    int? price,
    required int createdBy,
    required DateTime createdTime,
    required int status,
    required int updatedBy,
    required DateTime updatedTime,
  })  : id = id,
        scrapCategoryId = scrapCategoryId,
        unit = unit,
        price = price,
        createdBy = createdBy,
        createdTime = createdTime,
        status = status,
        updatedBy = updatedBy,
        updatedTime = updatedTime;

  int get getId => this.id;

  set setId(int id) => this.id = id;

  get getScrapCategoryId => this.scrapCategoryId;

  set setScrapCategoryId(scrapCategoryId) =>
      this.scrapCategoryId = scrapCategoryId;

  get getUnit => this.unit;

  set setUnit(unit) => this.unit = unit;

  get getPrice => this.price;

  set setPrice(price) => this.price = price;

  get getCreatedBy => this.createdBy;

  set setCreatedBy(createdBy) => this.createdBy = createdBy;

  get getCreatedTime => this.createdTime;

  set setCreatedTime(createdTime) => this.createdTime = createdTime;

  get getStatus => this.status;

  set setStatus(status) => this.status = status;

  get getUpdatedBy => this.updatedBy;

  set setUpdatedBy(updatedBy) => this.updatedBy = updatedBy;

  get getUpdatedTime => this.updatedTime;

  set setUpdatedTime(updatedTime) => this.updatedTime = updatedTime;
}

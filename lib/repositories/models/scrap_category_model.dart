import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';

class ScrapCategoryModel extends Comparable<ScrapCategoryModel> {
  int id;
  String name;
  String imageUrl;
  List<ScrapCategoryDetailModel> unitList;

  List<ScrapCategoryDetailModel> get getUnitList => this.unitList;

  set setUnitList(List<ScrapCategoryDetailModel> unitList) =>
      this.unitList = unitList;

  ScrapCategoryModel(this.id, this.name, this.imageUrl, this.unitList);

  get getId => this.id;

  set setId(id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getImageUrl => this.imageUrl;

  set setImageUrl(imageUrl) => this.imageUrl = imageUrl;

  @override
  int compareTo(ScrapCategoryModel other) {
    return this.name.compareTo(other.name);
  }
}

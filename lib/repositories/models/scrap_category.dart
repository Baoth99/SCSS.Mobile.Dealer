class ScrapCategoryModel extends Comparable<ScrapCategoryModel> {
  int id;
  String name;
  String imageUrl;

  ScrapCategoryModel(this.id, this.name, this.imageUrl);

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

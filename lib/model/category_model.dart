class CategoryModel {
  final int id;
  final String name;
  final String image;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      imageUrl: json["image_url"],
    );
  }
}

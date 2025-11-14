import 'dart:convert';

class SubCategory {
  final String id;
  final String categoryId;
  final String categoryName;
  final String image;
  final String subCategoryName;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.subCategoryName,
  });

  // Deserialize (Convert JSON to Category object)
  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      image: json['image'] as String,
      subCategoryName: json['subCategoryName'] as String,
    );
  }

  // Serialize (Convert Category object to JSON map)
  Map<String, dynamic> toJson() {
    return {
      '_id': id, // ✅ Make this match backend if it expects "_id"
      'categoryId': categoryId,
      'categoryName': categoryName,
      'image': image,
      'subCategoryName': subCategoryName,
    };
  }

  // Serialize (Convert Category object to JSON string)
  String toJsonString() => json.encode(toJson());

  // Deserialize from a JSON string to a Category object
  factory SubCategory.fromJsonString(String source) {
    final Map<String, dynamic> jsonData = json.decode(source);
    return SubCategory.fromJson(jsonData);
  }
}

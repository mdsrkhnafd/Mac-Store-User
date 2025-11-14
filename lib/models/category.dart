import 'dart:convert';

class Category {
  final String id;
  final String name;
  final String image;
  final String banner;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
  });

  // Deserialize (Convert JSON to Category object)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      banner: json['banner'] as String,
    );
  }

  // Serialize (Convert Category object to JSON map)
  Map<String, dynamic> toJson() {
    return {
      '_id': id, // ✅ Make this match backend if it expects "_id"
      'name': name,
      'image': image,
      'banner': banner,
    };
  }

  // Serialize (Convert Category object to JSON string)
  String toJsonString() => json.encode(toJson());

  // Deserialize from a JSON string to a Category object
  factory Category.fromJsonString(String source) {
    final Map<String, dynamic> jsonData = json.decode(source);
    return Category.fromJson(jsonData);
  }
}

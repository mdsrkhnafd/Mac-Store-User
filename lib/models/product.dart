import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final double productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String vendorFullName;
  final String subCategory;
  final List<String> images;
  final double averageRating;
  final int totalRatings;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.vendorId,
    required this.vendorFullName,
    required this.subCategory,
    required this.images,
    this.averageRating = 0.0,
    this.totalRatings = 0,
  });

  // Serialize (Convert Category object to JSON map)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'vendorId': vendorId,
      'vendorFullName': vendorFullName,
      'subCategory': subCategory,
      'images': images,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    };
  }

  // Deserialize (Convert JSON to Category object)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String,
      productName: json['productName'] as String,
      // Handle case where productPrice might be an int or double
      productPrice: (json['productPrice'] is int)
          ? (json['productPrice'] as int).toDouble()
          : (json['productPrice'] as double),
      quantity: json['quantity'] as int,
      description: json['description'] as String,
      category: json['category'] as String,
      vendorId: json['vendorId'] as String,
      vendorFullName: json['vendorFullName'] as String,
      subCategory: json['subCategory'] as String,
      images: List<String>.from(json['images'] as List<dynamic>),
      averageRating: (json['averageRating'] is int ?  (json['averageRating']  as int).toDouble() : json['averageRating'] as double),
      totalRatings: json['totalRatings'] as int,
    );
  }

  // Serialize (Convert Category object to JSON string)
  String toJsonString() => json.encode(toJson());

  // Deserialize from a JSON string to a Category object
  factory Product.fromJsonString(String source) {
    final Map<String, dynamic> jsonData = json.decode(source);
    return Product.fromJson(jsonData);
  }
}

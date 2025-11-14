

import 'dart:convert';

class ProductReview {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;

  ProductReview({
    required this.id,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['_id'] as String,
      buyerId: json['buyerId'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      productId: json['productId'] as String,
      rating: json['rating'] as double,
      review: json['review'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'buyerId': buyerId,
      'email': email,
      'fullName': fullName,
      'productId': productId,
      'rating': rating,
      'review': review,
    };
  }

  // Serialize (Convert Order object to JSON string)
  String toJsonString() => json.encode(toJson());

  // Deserialize from a JSON string to an Order object
  factory ProductReview.fromJsonString(String source) {
    final Map<String, dynamic> jsonData = json.decode(source);
    return ProductReview.fromJson(jsonData);
  }

}
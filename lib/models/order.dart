import 'dart:convert';

class Order {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String productName;
  final double productPrice;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;


  Order({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
  });

  // Serialize (Convert Order object to JSON map)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'delivered': delivered,
    };
  }

  // Deserialize (Convert JSON to Order object)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      locality: json['locality'] as String,
      productName: json['productName'] as String,
      productPrice: (json['productPrice'] is int)
          ? (json['productPrice'] as int).toDouble() // Ensure price is double
          : (json['productPrice'] as double),
      quantity: json['quantity'] as int,
      category: json['category'] as String,
      image: json['image'] as String,
      buyerId: json['buyerId'] as String,
      vendorId: json['vendorId'] as String,
      processing: json['processing'] as bool,
      delivered: json['delivered'] as bool,
    );
  }

  // Serialize (Convert Order object to JSON string)
  String toJsonString() => json.encode(toJson());

  // Deserialize from a JSON string to an Order object
  factory Order.fromJsonString(String source) {
    final Map<String, dynamic> jsonData = json.decode(source);
    return Order.fromJson(jsonData);
  }
}

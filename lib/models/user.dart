import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

  // Serialize (Convert Category object to JSON map)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'token': token,
    };
  }

  // Deserialize (Convert JSON to Category object)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? "",
      fullName: json['fullName'] as String? ?? "",
      email: json['email'] as String? ?? "",
      state: json['state'] as String? ?? "",
      city: json['city'] as String? ?? "",
      locality: json['locality'] as String? ?? "",
      password: json['password'] as String? ?? "",
      token: json['token'] as String? ?? "",
    );
  }

  // Serialize (Convert Category object to JSON string)
  String toJsonString() => json.encode(toJson());

  // Deserialize from a JSON string to a Category object
  factory User.fromJsonString(String source) {
    final Map<String, dynamic> jsonData = json.decode(source);
    return User.fromJson(jsonData);
  }
}

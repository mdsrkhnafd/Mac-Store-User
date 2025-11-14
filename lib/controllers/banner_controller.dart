import 'dart:convert';
import 'package:http/http.dart' as http;

import '../global_variable.dart';
import '../models/banner_model.dart';

class BannerController {

  // get all banners

  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/banner"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Assuming the response is a JSON object with a "banners" key
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'banners' is a key in the JSON response that holds the list of banners
        if (jsonData['banners'] != null) {
          List<dynamic> bannerList = jsonData['banners'];

          // Map the list of banners to a list of BannerModel objects
          List<BannerModel> banners = bannerList
              .map((item) => BannerModel.fromMap(item))
              .toList();

          return banners;
        } else {
          throw Exception('Banners key not found in response');
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print("Error loading banners: $e");
      return [];
    }
  }

}
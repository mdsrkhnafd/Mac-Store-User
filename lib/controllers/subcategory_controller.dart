import 'dart:convert';

import 'package:mac_store_app/models/subcategory.dart';
import 'package:http/http.dart' as http;

import '../global_variable.dart';

class SubcategoryController {

  Future<List<SubCategory>> getSubCategoriesByCategoryName(String categoryName) async {
    try {
      http.Response response = await http.get(Uri.parse("$uri/api/category/$categoryName/subcategories"));
      if (response.statusCode == 200) {

        final Map<String , dynamic> jsonData = jsonDecode(response.body);

        if(jsonData['subCategories'] != null) {
          final List<dynamic> data = jsonData['subCategories'];
          List<SubCategory> subcategories = data.map((subcategory) => SubCategory.fromJson(subcategory)).toList();

          return subcategories;
        }
        else {
          throw Exception('No subcategories found');
        }
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      return [];
    }
  }
}
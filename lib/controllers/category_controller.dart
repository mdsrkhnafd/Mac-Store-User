
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_variable.dart';
import '../models/category.dart';


class CategoryController {

  // get all categories
  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(Uri.parse("$uri/api/categories"));
      if (response.statusCode == 200) {

        final Map<String , dynamic> jsonData = jsonDecode(response.body);

        if(jsonData['categories'] != null) {
          final List<dynamic> data = jsonData['categories'];
          List<Category> categories = data.map((category) => Category.fromJson(category)).toList();

          return categories;
        }
        else {
          throw Exception('No categories found');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
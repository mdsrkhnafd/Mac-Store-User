import 'dart:convert'; // Import for jsonDecode
import 'package:mac_store_app/models/product.dart';
import 'package:http/http.dart' as http;
import '../global_variable.dart';

class ProductController {
  // Define a function that returns a future containing a list of Product model objects
  Future<List<Product>> loadPopularProducts() async {
    // Use a try block to handle any exceptions that might occur in the HTTP request process
    try {
      // Send GET request to the API
      http.Response response = await http.get(Uri.parse("$uri/api/popular-products"));

      // Log the response body
      print('Response Body: ${response.body}');  // Debugging: print full response body

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Log the decoded JSON
        print('Decoded JSON: $jsonData'); // Debugging: print the decoded JSON

        // Check if 'popularProducts' key exists and is not empty
        if (jsonData['popularProducts'] != null && jsonData['popularProducts'].isNotEmpty) {
          final List<dynamic> data = jsonData['popularProducts'];

          // Log the data to see the contents of the list
          print('Popular Products: $data');

          // Map the data to Product models
          List<Product> products = data.map((product) => Product.fromJson(product)).toList();

          // Log the list of products created from the data
          print('Mapped Products: $products');

          return products;
        } else {
          print('No popular products found');
          throw Exception('No popular products found');
        }
      } else {
        print('Failed to load products with status code: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // fetch products by category
  Future<List<Product>> loadProductByCategory(String category) async {
    // Use a try block to handle any exceptions that might occur in the HTTP request process
    try {
      // Send GET request to the API
      http.Response response = await http.get(Uri.parse("$uri/api/products-by-category/$category"));

      // Log the response body
      print('Response Body: ${response.body}');  // Debugging: print full response body

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Log the decoded JSON
        print('Decoded JSON: $jsonData'); // Debugging: print the decoded JSON

        // Check if 'popularProducts' key exists and is not empty
        if (jsonData['products'] != null && jsonData['products'].isNotEmpty) {
          final List<dynamic> data = jsonData['products'];

          // Log the data to see the contents of the list
          print('Fetch Products By Category: $data');

          // Map the data to Product models
          List<Product> products = data.map((product) => Product.fromJson(product)).toList();

          // Log the list of products created from the data
          print('Mapped Products: $products');

          return products;
        } else {
          print('No products found by category');
          throw Exception('No products found by category');
        }
      } else {
        print('Failed to load products with status code: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}

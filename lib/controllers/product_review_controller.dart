import 'dart:convert';

import 'package:mac_store_app/models/product_review.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/services/manage_http_response.dart';

import '../global_variable.dart';


class ProductReviewController {

  uploadReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context,
}) async {
    try {
      final ProductReview productReview = ProductReview(
        id: '',
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        productId: productId,
        rating: rating,
        review: review,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/product-review'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(productReview.toJson()),
      );

      manageHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, 'Review uploaded successfully');
      },);

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
import 'dart:convert';

import 'package:mac_store_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/services/manage_http_response.dart';
import '../global_variable.dart';

class OrderController {
  // function to upload orders
  uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required double productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required context,
  }) async {

    try {
      final Order order =  Order(
        id: '',
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
      );

      http.Response response = await http.post(Uri.parse("$uri/api/orders"),
      body: jsonEncode(order.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      manageHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, 'You have placed an order');
      },);


    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // Method to Get all orders by buyerId
  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {

      http.Response response = await http.get(Uri.parse('$uri/api/orders/$buyerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      // check status code
      if(response.statusCode == 200){
        List<dynamic> jsonData = jsonDecode(response.body);

        // Map the data to Product models
        List<Order> orders = jsonData.map((order) => Order.fromJson(order)).toList();

        return orders;
      }
      else {
        throw Exception('Failed to load Orders');
      }
      
    } catch (e) {
      print(e.toString());
      throw Exception('Error Loading Orders');
    }
  }

  // delete order by Id
 Future<void> deleteOrder({required String id , required context}) async {
    try {

      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      // handel the http Response
      manageHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, 'Order Deleted successfully');
      },);

    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
 }
}

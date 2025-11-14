import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends StateNotifier<Map<String, Cart>> {
  CartProvider() : super({}) {
    _loadCartItems();
  }

  // A private method that loads items from shared preferences
  Future<void> _loadCartItems() async {
    // retrieve the shared preferences instance
    final prefs = await SharedPreferences.getInstance();
    // retrieve the JSON string from shared preferences
    final cartString = prefs.getString('cart_items');
    // check if the JSON string is not null
    if (cartString != null) {
      // decode the JSON string to a Map
      final Map<String, dynamic> cartMap = jsonDecode(cartString);
      // convert the Map to a Map of Favorite items
      final cartItems = cartMap.map((key, value) =>
          MapEntry(key, Cart.fromJson(value)));
      // update the state with the loaded favorites
      state = cartItems;
    }
  }

  // A Private method that saves the current list of favorite items to shared preferences
  Future<void> _saveCartItems() async {
    // retrieve the shared preferences instance
    final prefs = await SharedPreferences.getInstance();
    // encoding the current state (Map of favorite items) as a JSON string
    final cartString = jsonEncode(state);
    // save the JSON string to shared preferences
    await prefs.setString('cart_items', cartString);
  }

  // method for add to cart
  void addProductToCart({
    required String productName,
    required double productPrice,
    required String category,
    required List<String> images,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    // check if the product is already in the cart
    if (state.containsKey(productId)) {
      // if the product is already in the cart, update its quantity and may update other details
      state = {
        ...state,
        productId: Cart(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          images: state[productId]!.images,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        )
      };
      _saveCartItems();
    } else {
      state = {
        ...state,
        productId: Cart(
          productName: productName,
          productPrice: productPrice,
          category: category,
          images: images,
          vendorId: vendorId,
          productQuantity: productQuantity,
          quantity: quantity,
          productId: productId,
          description: description,
          fullName: fullName,
        )
      };
      _saveCartItems();
    }
  }

  // method to increment the quantity of a product in the cart
void incrementCartItem(String productId) {
    if(state.containsKey(productId)) {
      state[productId]!.quantity++;

      // Notify listeners that state has changed
      state = {...state};
      _saveCartItems();
    }
}

  // method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if(state.containsKey(productId)) {
      // final cartItem = state[productId]!;
      state[productId]!.quantity--;

      // Notify listeners that state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  // method to remove the product in the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    // Notify listeners that the state has changed
    state = {...state};
    _saveCartItems();
  }

  // method to calculate the amount of items we have in the cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId , cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }

  Map<String , Cart> get getCartItems => state;

}

// Define a StateNotifierProvider to expose an instance of the CartProvider
// make an accessible with in the whole App

final cartProvider = StateNotifierProvider<CartProvider , Map<String , Cart>>((ref) {
  return CartProvider();
});

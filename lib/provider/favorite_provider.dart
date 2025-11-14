import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// make an accessible with in the whole App
final favoriteProvider = StateNotifierProvider<FavoriteProvider , Map<String , Favorite>>((ref) {
  return FavoriteProvider();
});




class FavoriteProvider extends StateNotifier<Map<String , Favorite>> {
  FavoriteProvider() : super({}) {
    _loadFavorites();
  }

  // A private method that loads items from shared preferences
  Future<void> _loadFavorites() async {
    // retrieve the shared preferences instance
    final prefs = await SharedPreferences.getInstance();
    // retrieve the JSON string from shared preferences
    final favoriteString = prefs.getString('favorites');
    // check if the JSON string is not null
    if (favoriteString != null) {
      // decode the JSON string to a Map
      final Map<String, dynamic> favoriteMap = jsonDecode(favoriteString);
      // convert the Map to a Map of Favorite items
      final favorites = favoriteMap.map((key, value) =>
          MapEntry(key, Favorite.fromJson(value)));
      // update the state with the loaded favorites
      state = favorites;
    }
  }

  // A Private method that saves the current list of favorite items to shared preferences
  Future<void> _saveFavorites() async {
    // retrieve the shared preferences instance
    final prefs = await SharedPreferences.getInstance();
    // encoding the current state (Map of favorite items) as a JSON string
    final favoriteString = jsonEncode(state);
    // save the JSON string to shared preferences
    await prefs.setString('favorites', favoriteString);
  }

  void addProductToFavorite({
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
     state[productId] = Favorite(
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
     );

     state = {...state};
     _saveFavorites();
  }

  // remove from Wishlist list
  void removeFavoriteItem(String productId) {
    state.remove(productId);
    // Notify listeners that the state has changed
    state = {...state};
    _saveFavorites();
  }

  Map<String , Favorite> get getFavoriteItems => state;

}
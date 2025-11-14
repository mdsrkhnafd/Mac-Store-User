import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);

  // set product list
  void setProducts(List<Product> products) {
    state = products;
  }
}

final productProvider = StateNotifierProvider<ProductProvider , List<Product>>((ref) {
  return ProductProvider();
});

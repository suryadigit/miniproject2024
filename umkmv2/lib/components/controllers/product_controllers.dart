import 'package:flutter/material.dart';

import '../models/model_product.dart';
import '../services/services_product.dart';
 
class ProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  List<ProductModel>? _products;
  bool _isLoaded = false;

  List<ProductModel>? get products => _products;
  bool get isLoaded => _isLoaded;

  void getProducts() async {
    _isLoaded = true;
    notifyListeners();
    try {
      final response = await _productService.getProduct();
      if (response.statusCode == 200) {
        _products = List<ProductModel>.from(
            response.data.map((x) => ProductModel.fromJson(x)));
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoaded = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    if (_products != null) {
      final filteredProducts = _products!
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _products = filteredProducts;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _productService.deleteProduct(id);
      if (response.statusCode == 200) {
        _products!.removeWhere((product) => product.id == id);
        notifyListeners();
      } else {
        debugPrint('Error: Gagal menghapus produk');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void resetProducts() {
    getProducts();
  }
}

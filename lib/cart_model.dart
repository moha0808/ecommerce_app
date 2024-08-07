import 'package:flutter/material.dart';

import 'product.dart';

class CartModel with ChangeNotifier {
  final List<Product> _products = [];
  final Map<int, int> _quantities = {};

  List<Product> get products => _products;
  Map<int, int> get quantities => _quantities;

  void add(Product product) {
    if (_quantities.containsKey(product.id)) {
      _quantities[product.id] = _quantities[product.id]! + 1;
    } else {
      _products.add(product);
      _quantities[product.id] = 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_quantities.containsKey(product.id)) {
      if (_quantities[product.id]! > 1) {
        _quantities[product.id] = _quantities[product.id]! - 1;
      } else {
        _products.remove(product);
        _quantities.remove(product.id);
      }
    }
    notifyListeners();
  }

  void delete(Product product) {
    _products.remove(product);
    _quantities.remove(product.id);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in _products) {
      total += product.price * _quantities[product.id]!;
    }
    return total;
  }

  void clear() {
    _products.clear();
    _quantities.clear();
    notifyListeners();
  }
}

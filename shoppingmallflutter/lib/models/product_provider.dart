import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product.dart';

import 'package:shoppingmallflutter/main.dart';

class ProductProvider with ChangeNotifier {
  late CollectionReference productReference;
  List<Product> products = [];

  ProductProvider({reference}) {
    //print("ProductProvider in");
    productReference = reference ?? firestore.collection('product');
  }

  Future<void> fetchItems() async {
    //print("ProductProvider fetchItems in");
    products = await productReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Product.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
    //print("ProductProvider fetchItems out");
  }
}
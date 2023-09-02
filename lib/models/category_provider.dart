import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'category.dart';

import 'package:shoppingmallflutter/main.dart';

class CategoryProvider with ChangeNotifier {
  late CollectionReference categoryReference;
  List<Category> categorys = [];

  CategoryProvider({reference}) {
    print("CategoryProvider in");
    categoryReference = reference ?? firestore.collection('category');
  }

  Future<void> fetchItems() async {
    print("CategoryProvider fetchItems in");
    categorys = await categoryReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Category.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
    print("CategoryProvider fetchItems out");
  }
}
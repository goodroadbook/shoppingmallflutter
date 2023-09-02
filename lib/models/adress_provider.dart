import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'address.dart';

import 'package:shoppingmallflutter/main.dart';

class AdressProvider with ChangeNotifier {
  late CollectionReference addressReference;
  List<Address> addressinfo = [];

  AdressProvider({reference}) {
    print("AdressProvider in");
    addressReference = reference ?? firestore.collection('address')
        .doc(auth.currentUser!.uid).collection('shippingaddress');
  }

  Future<void> fetchItems() async {
    print("AdressProvider fetchItems in");
    addressinfo = await addressReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Address.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
    print("AdressProvider fetchItems out");
  }
}
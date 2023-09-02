import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'member.dart';

import 'package:shoppingmallflutter/main.dart';

class MemberProvider with ChangeNotifier {
  late CollectionReference memberReference;
  List<Member> members = [];

  MemberProvider({reference}) {
    memberReference = reference ?? firestore.collection('member');
  }

  Future<void> fetchItems() async {
    members = await memberReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Member.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
  }
}
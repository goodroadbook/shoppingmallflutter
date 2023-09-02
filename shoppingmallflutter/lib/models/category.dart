import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  late String id;
  late String categoryname;
  late String categorycode;
  late String categorylevel;
  late String img;

  Category({
    required this.id,
    required this.categoryname,
    required this.categorycode,
    required this.categorylevel,
    required this.img,
  });

  Category.fromSnapshot(DocumentSnapshot snapshot) {
    print("Category fromSnapshot in ");

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    categoryname = data['categoryname'];
    categorycode = data['categorycode'];
    categorylevel = data['categorylevel'];
   img = data['img'];

    print("Categorys Data = ${categoryname},${categorycode},${categorylevel}");
  }
}
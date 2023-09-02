import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  late String id;
  late String productid;
  late String cartregdate;
  late String title;
  late String image;
  late String purchaseprice;
  late int purchasecount;
  late bool select = false;

  Cart({
    required this.id,
    required this.productid,
    required this.cartregdate,
    required this.title,
    required this.image,
    required this.purchaseprice,
    required this.purchasecount,
  });

  Cart.fromSnapshot(DocumentSnapshot snapshot) {
    print("Cart fromSnapshot in ");

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    productid = data['productid'];
    cartregdate = data['cartregdate'];
    title = data['title'];
    image = data['image'];
    purchaseprice = data['purchaseprice'];
    purchasecount = data['purchasecount'];

    print("Cart Data = ${productid},${cartregdate}");
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrder {
  late String id;
  late String productid;
  late String orderregdate;
  late String title;
  late String image;
  late String purchaseprice;
  late String review;
  late int purchasecount;
  late int deliverystate;
  late bool select = false;

  MyOrder({
    required this.id,
    required this.productid,
    required this.orderregdate,
    required this.title,
    required this.image,
    required this.purchaseprice,
    required this.review,
    required this.purchasecount,
    required this.deliverystate,
  });

  MyOrder.fromSnapshot(DocumentSnapshot snapshot) {
    print("MyOrder fromSnapshot in ");

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    productid = data['productid'];
    orderregdate = data['orderregdate'];
    title = data['title'];
    image = data['image'];
    purchaseprice = data['purchaseprice'];
    review = data['review'];
    purchasecount = data['purchasecount'];
    deliverystate = data['deliverystate'];

    print("MyOrder Data = ${productid},${orderregdate}");
  }
}
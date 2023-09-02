import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late String id;
  late String proid;
  late String title;
  late String description;
  late String brand;
  late String image;
  late String regdate;
  late String updatedate;
  late String sellerid;
  late String price;
  late String discountprice;
  late String discountrate;
  late String youtubeid;
  late String detailimg;
  late int stock;
  late int grade;
  late int reivewcount;

  Product({
    required this.id,
    required this.proid,
    required this.title,
    required this.description,
    required this.brand,
    required this.image,
    required this.regdate,
    required this.updatedate,
    required this.sellerid,
    required this.price,
    required this.discountprice,
    required this.discountrate,
    required this.youtubeid,
    required this.detailimg,
    required this.stock,
    required this.grade,
    required this.reivewcount,
  });

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    //print("Product fromSnapshot in ");

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    proid = data['proid'];
    title = data['title'];
    description = data['description'];
    brand = data['brand'];
    image = data['image'];
    regdate = data['regdate'];
    updatedate = data['updatedate'];
    sellerid = data['sellerid'];
    price = data['price'];
    discountprice = data['discountprice'];
    discountrate = data['discountrate'];
    youtubeid = data['youtubeid'];
    detailimg = data['detailimg'];
    stock = data['stock'];
    grade = data['grade'];
    reivewcount = data['reviewcount'];

    //print("Product Data = ${proid},${title},${description},${brand},${image},${regdate},${updatedate},${stock},${sellerid},${price},${discountprice},${discountrate},${grade}");
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  late String id;
  late String detail;
  late String useremail;
  late String regdate;

  Review({
    required this.id,
    required this.detail,
    required this.useremail,
    required this.regdate,
  });

  Review.fromSnapshot(DocumentSnapshot snapshot) {
    //print("Product fromSnapshot in ");

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    detail = data['detail'];
    useremail = data['useremail'];
    regdate = data['regdate'];

    //print("Product Data = ${detail},${useremail},${regdate});
  }
}
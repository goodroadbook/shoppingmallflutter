import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  late String id;
  late String name;
  late String phone;
  late String address;
  late String postcode;
  late String jibunaddress;
  late String detailaddress;
  late String defaultstatus;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.postcode,
    required this.jibunaddress,
    required this.detailaddress,
    required this.defaultstatus,
  });

  Address.fromSnapshot(DocumentSnapshot snapshot) {
    print("Adress fromSnapshot in ");

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    name = data['name'];
    phone = data['phone'];
    address = data['address'];
    postcode = data['postcode'];
    jibunaddress = data['jibunaddress'];
    detailaddress = data['detailaddress'];
    defaultstatus = data['defaultstatus'];

    print("Adress Data = ${name},${address},${postcode},${jibunaddress},${detailaddress},${defaultstatus}");
  }
}
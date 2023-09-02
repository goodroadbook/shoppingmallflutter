import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  late String id;
  late String email;
  late String pwd;
  late String name;
  late String address;
  late String level;

  Member({
    required this.id,
    required this.email,
    required this.pwd,
    required this.name,
    required this.address,
    required this.level,
  });

  Member.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    email = data['email'];
    pwd = data['pwd'];
    name = data['name'];
    address = data['address'];
    level = data['level'];
  }
}
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoppingmallflutter/screens/login_screen.dart';
import 'package:shoppingmallflutter/main.dart';
import 'package:shoppingmallflutter/screens/adress_screen.dart';
import 'package:shoppingmallflutter/screens/order_screen.dart';
import 'package:shoppingmallflutter/screens/return_screen.dart';
import 'package:shoppingmallflutter/screens/review_screen.dart';
import 'package:shoppingmallflutter/models/address.dart';

class TabProfileWidget extends StatefulWidget {
  const TabProfileWidget({super.key});

  @override
  State<TabProfileWidget> createState() => _TabProfileWidgetState();
}

class _TabProfileWidgetState extends State<TabProfileWidget> {

  String currentrecipient = "";
  String currentaddress = "";
  String currentphonenumber = "";

  @override
  void initState() {
    super.initState();
    print("TabProfileWidget initState in");

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) =>
            const LoginMemberPage(title: 'NOTI.MARKET')), (route) => true);
        /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) =>
            const AuthGate()), (route) => true);*/
      } else {
        print('User is signed in!');
        getUserFromSocial();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("TabProfileWidget didChangeDependencies in");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children : [
          Container(
            width: double.infinity,
            height: 350,
            child: Card(
              color: Colors.white,
              margin : const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                child : Column(
                  children : [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 10),
                        Text(
                            "회원정보",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(width: double.infinity, child: Divider(color: Colors.grey, thickness: 1.0)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child : Image.asset('images/profile_default.png', width: 70, height: 70,),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 70,
                          width: 70,
                            child : const Text(
                              "남진하",
                              style: TextStyle(fontSize: 20),
                            ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            height: 70,
                            child : OutlinedButton.icon(
                              onPressed: () {  },
                              icon : const Icon(Icons.logout, size: 18),
                              label: const Text("로그아웃"),
                            )
                          )
                        )
                      ]
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : 80,
                              child: const Text("고객명"),
                            ),
                            Container(
                              width : 150,
                              child: const Text("남진하"),
                            )
                          ]
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : 80,
                              child: const Text("비밀번호"),
                            ),
                            Container(
                              width : 150,
                              child: const Text("*********"),
                            )
                          ]
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : 80,
                              child: const Text("이메일"),
                            ),
                            Container(
                              width : 150,
                              child: const Text("jjinsama@gmail.com"),
                            )
                          ]
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : 80,
                              child: const Text("연락처"),
                            ),
                            Container(
                              width : 150,
                              child: const Text("010-7369-0833"),
                            )
                          ]
                        ),
                        const SizedBox(height: 20),
                      ]
                    ),
                    const SizedBox(width: double.infinity, child: Divider(color: Colors.grey, thickness: 0.5)),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: const Text("수령인"),
                            ),
                            Container(
                              width: 150,
                              child: Text("${currentrecipient}"),
                            ),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child : TextButton.icon(
                                      onPressed: () {
                                        openAdressScreen();
                                      },
                                      icon : const Icon(Icons.edit_location, size: 18),
                                      label: const Text("주소록 관리"),
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: const Text("주소"),
                            ),
                            Expanded(
                              child: Container(
                                child: Text("${currentaddress}"),
                              )
                            )
                          ]
                        ),
                        Row(
                            children: [
                              Container(
                                width: 80,
                                child: const Text("연락처"),
                              ),
                              Container(
                                width: 150,
                                child: Text("${currentphonenumber}"),
                              ),
                            ]
                        )
                      ],
                    )
                  ],
                )
              )
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: Container(
            child: ListView(children: showProilfeMenu(),),
            )
          )
        ]
      );
  }

  void openAdressScreen() async {
    final Address result = await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
        const AdressScreenPage(title: 'NOTI.MARKET')), (route) => true);

    currentrecipient = result.name;
    currentaddress = result.address + " " + result.detailaddress;
    currentphonenumber = result.phone;
    setState(() {
    });
    print("result = ${result.address}");
  }


  void openOrderScreen() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
            const OrderScreenPage(title: 'NOTI.MARKET',)), (route) => true);
  }

  void openReturnScreen() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
            const ReturnScreenPage(title: 'NOTI.MARKET',)), (route) => true);
  }

  void openReviewScreen() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
            const ReviewScreenPage(title: 'NOTI.MARKET',)), (route) => true);
  }

  List<ListTile> showProilfeMenu() {
    List<ProfileMenu> profileMenus = buildProfileMenu();
    List<ListTile> list = [];
    for(var ProfileMenu in profileMenus) {
      list.add(ListTile(
        title: Text(ProfileMenu.name),
        leading: CircleAvatar(
          child: Icon(ProfileMenu.icon),
          backgroundColor: Colors.black,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          print("showProilfeMenu = in, ${ProfileMenu.index}");
          switch(ProfileMenu.index) {
            case 0:
              openOrderScreen();
              break;
            case 1:
              openReturnScreen();
              break;
            case 2:
              openReviewScreen();
              break;
            case 3:
              break;
            case 4:
              break;
            default:
              break;
          }
        },
      ));
    }
    return list;
  }
}

class ProfileMenu {
  int index;
  String name;
  IconData icon;
  ProfileMenu(this.index, this.name, this.icon);
}

List<ProfileMenu> buildProfileMenu() {
  List<ProfileMenu> profileMenus = [];
  profileMenus.add(ProfileMenu(0, "주문목록", Icons.delivery_dining));
  profileMenus.add(ProfileMenu(1, "취소/반품/교환목록", Icons.cancel));
  profileMenus.add(ProfileMenu(2, "리뷰 관리", Icons.reviews));
  profileMenus.add(ProfileMenu(3, "할인쿠폰", Icons.discount_sharp));
  profileMenus.add(ProfileMenu(4, "고객센터", Icons.help_center));
  return profileMenus;
}

User? getUserFromSocial() {
  final user = auth.currentUser;
  if (user != null) {
    for (final providerProfile in user.providerData) {
      // ID of the provider (google.com, apple.cpm, etc.)
      final provider = providerProfile.providerId;

      // UID specific to the provider
      final uid = providerProfile.uid;

      // Name, email address, and profile photo URL
      final name = providerProfile.displayName;
      final emailAddress = providerProfile.email;
      final profilePhoto = providerProfile.photoURL;

      print("_LoginMemberPageState getUserFromSocial user info = ${uid}, ${name}, ${emailAddress}");
    }
  }
  return user;
}



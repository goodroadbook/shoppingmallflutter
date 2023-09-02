import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmallflutter/models/adress_provider.dart';
import 'package:shoppingmallflutter/main.dart';
import 'package:shoppingmallflutter/models/address.dart';

class AdressScreenPage extends StatefulWidget {
  const AdressScreenPage({super.key, required this.title});

  final String title;

  @override
  State<AdressScreenPage> createState() => _AdressScreenPageState();
}

class _AdressScreenPageState extends State<AdressScreenPage> {
  String postcode = '-';
  String address = '-';
  String jibunaddress = '-';

  final addressNameController = TextEditingController();
  final addressPhoneController = TextEditingController();
  final addressDetailController = TextEditingController();
  List<Address> addressinfo = [];

  @override
  void initState() {
    super.initState();
    print("AdressScreenPage initState in");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getAddressDataFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child : SingleChildScrollView(
            child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding : const EdgeInsets.all(10),
                          width: double.maxFinite,
                          height: 70,
                          child: TextField(
                            controller: addressNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '수령자 성명 입력',),
                          )
                      ),
                      const SizedBox(height: 10,),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding : const EdgeInsets.all(10),
                          width: double.maxFinite,
                          height: 70,
                          child: TextField(
                            controller: addressPhoneController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '수령자 폰번호 입력',),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          width: double.maxFinite,
                          height: 70,
                          child : OutlinedButton.icon(
                            onPressed: () {
                              kakaoAdress();
                            },
                            icon : const Icon(Icons.add, size: 20),
                            label: const Text("배송지 추가"),
                          )
                      ),
                      Center(
                        child: SingleChildScrollView(
                          child: ((){

                          })(),
                        ),
                      ),
                      Center(
                        child: ((){
                          print("build - in myorderinfo.length = ${addressinfo.length}");
                          if(addressinfo.isEmpty) {
                            return const Center(child: CircularProgressIndicator(),);
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: addressinfo.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      title : Text(
                                        addressinfo[index].name,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      subtitle : Text(
                                        addressinfo[index].address,
                                        style: const TextStyle(fontSize: 16, color: Colors.red),
                                      ),
                                    onTap: () {
                                      Navigator.of(context).pop(addressinfo[index]);
                                    },
                                  );
                                },

                            );
                          }
                        })(),
                      ),
                    ],
              ),
            )
      )
    );
  }

  Future<void> kakaoAdress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          useLocalServer: true,
          localPort: 1024,
          // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
          callback: (Kpostal result) {
            setState(() async {
              this.postcode = result.postCode;
              this.address = result.address;
              this.jibunaddress = result.jibunAddress;
              print("AddressScreenPage kakaoAdress = ${postcode}, ${address}, ${jibunaddress}");
              print("AddressScreenPage kakaoAdress Current user = ${auth.currentUser!.uid}");
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  showDetailAddressDialog();
                });
              });
            });
          },
        ),
      ),
    );
  }

  void showDetailAddressDialog() {
    print("showDetailAddressDialog in");

    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("도로 주소 : ${address}\n"
                      "지번 주소 : ${jibunaddress}\n"
                      "우편 번호 : ${postcode}\n",
                  style: const TextStyle(fontSize: 12,),)
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("상세 주소를 입력 해주세요",),
                const SizedBox(height: 10,),
                TextField(
                  controller: addressDetailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '수령자 성명 입력',),
                )
              ],
            ),
            actions: <Widget>[
              SizedBox(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소'),
                  )
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    addAdresssToFirestore();
                    Navigator.pop(context);
                  },
                  child: const Text('추가하기'),
                ),
              ),
            ],
          );
        });
  }

  Future<void> getAddressDataFirestore() async {
    addressinfo = await firestore.collection('address').doc(auth.currentUser!.uid).collection('shippingaddress').get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Address.fromSnapshot(document);
      }).toList();
    });
    print("getAdressDataFirestore in addressinfo.length = ${addressinfo.length}");
    setState(() {
    });
  }

  Future<void> addAdresssToFirestore() async {
    await firestore.collection('address')
        .doc(auth.currentUser!.uid).collection('shippingaddress').doc()
        .set(
        { 'name' : addressNameController.text,
          'phone' : addressPhoneController.text,
          'postcode' : this.postcode,
          'address' : this.address,
          'jibunaddress' : this.jibunaddress,
          'detailaddress' : addressDetailController.text,
          'defaultstatus' : "default",
        }
        , SetOptions(merge : true));

    getAddressDataFirestore();
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shoppingmallflutter/models/myorder.dart';
import 'package:shoppingmallflutter/main.dart';

class OrderScreenPage extends StatefulWidget {
  const OrderScreenPage({super.key, required this.title,});

  final String title;

  @override
  State<OrderScreenPage> createState() => _OrderScreenPageState();
}

class _OrderScreenPageState extends State<OrderScreenPage> {

  List<MyOrder> myorderinfo = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getOrderDataFirestore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.black,
        ),
        body: Center(
                child :((){
                  print("build - in myorderinfo.length = ${myorderinfo.length}");
                  if(myorderinfo.isEmpty) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index){
                        return buildMyOrderCard(myorderinfo[index]);
                      },
                      itemCount: myorderinfo.length,
                    );
                  }
                })(),
              )
    );
  }

  Widget buildMyOrderCard(MyOrder myOrder) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: getDeliveryState(myOrder.deliverystate),
            ),
            const SizedBox(height: 10.0,),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                  maxLines: 2,
                  text: TextSpan(text: myOrder.title,
                      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,))
              ),
            ),
            const SizedBox(height: 10.0,),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: myOrder.image,
                      width: 120,
                      height: 120,
                      placeholder: (context, url) =>
                      const Center(
                        child: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url,
                          error) => const Icon(Icons.error),
                    )
                ),
                const SizedBox(width: 10.0,),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("구매 날짜 : ${myOrder.orderregdate} \n"
                          "구매 수량 : ${myOrder.purchasecount} \n"
                          "구매 가격 : ${myOrder.purchaseprice} 원"),
                    ),
                  ],
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children : [
                  SizedBox(
                      width: 160,
                      child: OutlinedButton(
                        onPressed: () {
                        },
                        child: const Text('교환, 반품 신청'),
                      )
                  ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: const Text('배송 조회'),
                    ),
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }

  Widget getDeliveryState(int state) {
    String str = "배송 상태 : 배송 준비 중";
      switch(state) {
        case 0:
          str = "배송 상태 : 배송 준비 중";
          break;
        case 1:
          str = "배송 상태 : 배송 중";
          break;
        case 2:
          str = "배송 상태 : 배송 완료";
          break;
        default:
          break;
      }

    return RichText(
        maxLines: 2,
        text: TextSpan(text: "${str}",
            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.green,)));
  }

  Future<void> getOrderDataFirestore() async {
    myorderinfo = await firestore.collection('order').doc(auth.currentUser!.uid).collection('myorder').get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return MyOrder.fromSnapshot(document);
      }).toList();
    });
    print("getOrderDataFirestore in myorderinfo.length = ${myorderinfo.length}");
    setState(() {
    });
  }
}
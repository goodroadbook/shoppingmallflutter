import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:shoppingmallflutter/main.dart';
import 'package:shoppingmallflutter/models/cart.dart';

class TabCartWidget extends StatefulWidget {
  const TabCartWidget({super.key});

  @override
  State<TabCartWidget> createState() => _TabCartWidgetState();
}

class _TabCartWidgetState extends State<TabCartWidget> {

  late List<Cart> cartinfo = [];
  int selcount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getCartDataFirestore();
  }

  @override
  Widget build(BuildContext context) {
    print("build - in cartinfo.length = ${cartinfo.length}");
    return SingleChildScrollView(
      child : Column(
        children: [
          Center(
            child :((){
                print("build - in cartinfo.length = ${cartinfo.length}");
                if(cartinfo.isEmpty) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  // Expanded 를 추가하지 않으면 스크롤이 안되는 이슈와 Bottom overflowed 이슈가 발생된다.
                  return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartinfo.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(cartinfo[index].title),
                              subtitle: Text(cartinfo[index].cartregdate),
                              value: cartinfo[index].select,
                              onChanged: (newvalue) {
                                setState(() {
                                  cartinfo[index].select = newvalue!;
                                });
                              },
                              secondary: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child : CachedNetworkImage(
                                    imageUrl: cartinfo[index].image,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                              ),
                              activeColor: Colors.grey,
                              checkColor: Colors.black,
                              isThreeLine: false,
                            );
                          }
                      );
                }
              })()
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children : [
                SizedBox(
                    width: 160,
                    child: OutlinedButton(
                      onPressed: () {
                        removeCartDataFirestore();
                      },
                      child: const Text('장바구니 제거'),
                    )
                ),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      for(Cart cart in cartinfo) {
                        if(cart.select) {
                          selcount++;
                        }
                      }
                      showPurchaseDialog();
                    },
                    child: const Text('구매하기'),
                  ),
                ),
              ]
          ),
        ],
      )
    );
  }

  void showPurchaseDialog() {
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
              children: const <Widget>[
                Center(
                  child: Text("선택하신 물품을 구매하시겠습니까?"),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("선택하신 물품은 총 ${selcount} 개 입니다.",),
              ],
            ),
            actions: <Widget>[
              SizedBox(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      selcount = 0;
                    },
                    child: const Text('취소'),
                  )
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {

                    setPurchaseDataFirestore();
                    Navigator.pop(context);
                    selcount = 0;
                  },
                  child: const Text('담기'),
                ),
              ),
            ],
          );
        });
  }

  Future<void> setPurchaseDataFirestore() async {
    for(Cart cart in cartinfo) {
      if(cart.select == true) {
        await firestore.collection('order')
            .doc(auth.currentUser!.uid)
            .collection('myorder')
            .doc().set(
            {
              "orderregdate": getToday(),
              "image": cart.image,
              "productid": cart.productid,
              "purchasecount": cart.purchasecount,
              "purchaseprice" : cart.purchaseprice,
              "title": cart.title,
              "review" : "",
              "deliverystate": 0,
            });
      }
    }
    removeCartDataFirestore();
    setState(() {
    });
  }

  Future<void> getCartDataFirestore() async {
    cartinfo = await firestore.collection('cart').doc(auth.currentUser!.uid).collection('mycart').get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Cart.fromSnapshot(document);
      }).toList();
    });
    print("getCartDataFirestore in cartinfo.length = ${cartinfo.length}");
    setState(() {
    });
  }

  Future<void> removeCartDataFirestore() async {
    List<Cart> temp = [];
    for(Cart cart in cartinfo) {
      if(cart.select) {
        await firestore.collection('cart').doc(auth.currentUser!.uid)
            .collection(
            'mycart').doc(cart.id)
            .delete();
        temp.add(cart);
      }
    }

    for(Cart cart in temp) {
      cartinfo.remove(cart);
    }

    print("removeCartDataFirestore in cartinfo.length = ${cartinfo.length}");
    setState(() {
    });
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:shoppingmallflutter/models/product.dart';
import 'package:shoppingmallflutter/main.dart';
import 'package:shoppingmallflutter/widgets/grade_level.dart';
import 'package:shoppingmallflutter/widgets/product_review.dart';

class DetailScreenPage extends StatefulWidget {
  const DetailScreenPage({super.key, required this.title, required this.proid, required this.youtubeid});

  final String title;
  final String proid;
  final String youtubeid;

  @override
  State<DetailScreenPage> createState() => _DetailScreenPageState();
}

class _DetailScreenPageState extends State<DetailScreenPage> {

  late List<Product> productinfo = [];
  late Product product;
  late YoutubePlayerController controller;
  final myPurchaseCount = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.youtubeid,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    print("Product id = ${widget.proid}");
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
        body: SingleChildScrollView(
            child: Column(
                children: [
                  const SizedBox(height: 20.0,),
                  FutureBuilder(
                      future: getFirestoreData(),
                      builder: (context, snapshot) {
                        //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                        if (productinfo.isEmpty /*|| reviewinfo.isEmpty*/) {
                          return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
                        }
                        else {
                          product = productinfo.first;
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 0),
                                child: Text(product.title,
                                  style: const TextStyle(fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),),
                              ),
                              const SizedBox(height: 20.0,),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    placeholder: (context,
                                        url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url,
                                        error) => const Icon(Icons.error),
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  )
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  Text(product.brand,
                                    style: const TextStyle(
                                      fontSize: 15, color: Colors.blue,),),
                                  const SizedBox(width: 50,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GradeLevelWidget(
                                        gradeLevel: product.grade,),
                                      const SizedBox(width: 5,),
                                      Text('(${product.reivewcount})',
                                        style: const TextStyle(
                                          fontSize: 15, color: Colors.blue,),),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 0),
                                child: Text(
                                  '${product.discountprice}원 (${product
                                      .discountrate}% 할인가)',
                                  style: const TextStyle(fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: YoutubePlayer(
                                  controller: controller,
                                ),
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: product.detailimg,
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
                              const SizedBox(height: 20.0,),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(10),
                                color: Colors.greenAccent,
                                child: const Text("상품평",
                                  style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),),
                              ),
                              ProductReviewlWidget(proid: product.proid,),
                              const SizedBox(height: 20.0,),
                            ],
                          );
                        }
                      })
                ]
            )
        ),
        bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 160,
                  child: OutlinedButton(
                    onPressed: () {
                      showPurchaseDialog(0, 0);
                    },
                    child: const Text('장바구니 담기'),
                  )
              ),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    showPurchaseDialog(1, 0);
                  },
                  child: const Text('구매하기'),
                ),
              ),
            ]
        )
    );
  }

  void showPurchaseDialog(final int type, final int error) {
    print("showPurchaseDialog type = ${type}, error = ${error}");

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
                Center(
                  child: getDialogContents(type, error),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("상품명 : ${product.title}",),
                const Text("[구매 수량]",),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: myPurchaseCount,
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
                    if(myPurchaseCount.text.isEmpty) {
                      Navigator.pop(context);
                      showPurchaseDialog (type, -1);
                      return;
                    }

                    if(type == 0) {
                      setCartDataFirestore();
                    } else {
                      setPurchaseDataFirestore();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('담기'),
                ),
              ),
            ],
          );
        });
  }

  Widget getDialogContents(int type, int error) {
    print("type = ${type}, error = ${error}");
    if(type == 0) {
      switch (error) {
        case -1:
          print("error = -1");
          return const Text("수량을 확인 해주세요. 장바구니에 담기를 할까요?");
        default:
          print("error = 0");
          return const Text("장바구니에 담기를 할까요?");
      }
    } else {
      switch (error) {
        case -1:
          print("error = -1");
          return const Text("수량을 확인 해주세요. 선택하신 물품을 구매하시겠습니까?");
        default:
          print("error = 0");
          return const Text("선택하신 물품을 구매하시겠습니까?");
      }
    }
  }

  Future<void> getFirestoreData() async {
    productinfo = await firestore.collection("product").where(
        "proid", isEqualTo: widget.proid).get().then((QuerySnapshot results) {
      return results.docs.map((DocumentSnapshot document) {
        return Product.fromSnapshot(document);
      }).toList();
    });
  }

  Future<void> setCartDataFirestore() async {
    await firestore.collection('cart')
        .doc(auth.currentUser!.uid)
        .collection('mycart')
        .doc().set(
        {
          "cartregdate" : getToday(),
          "image" : product.image,
          "productid" : product.proid,
          "purchasecount" : int.parse(myPurchaseCount.text),
          "purchaseprice" : product.price,
          "title" : product.title
        });
  }

  Future<void> setPurchaseDataFirestore() async {
    await firestore.collection('order')
        .doc(auth.currentUser!.uid)
        .collection('myorder')
        .doc().set(
        {
          "orderregdate" : getToday(),
          "image" : product.image,
          "productid" : product.proid,
          "purchasecount" : int.parse(myPurchaseCount.text),
          "purchaseprice" : product.price,
          "title" : product.title,
          "review" : "",
          "deliverystate" : 0,
        });
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }
}
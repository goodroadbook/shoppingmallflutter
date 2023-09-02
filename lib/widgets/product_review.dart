import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppingmallflutter/models/review.dart';
import 'package:shoppingmallflutter/main.dart';

class ProductReviewlWidget extends StatefulWidget {
  const ProductReviewlWidget({super.key, required this.proid});

  final String proid;

  @override
  State<ProductReviewlWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewlWidget> {

  late List<Review> reviewinfo = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReviewFirestoreData(),
      builder: (context, snapshot) {
        //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
        if (reviewinfo.isEmpty) {
          return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
        }
        else {
          return Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                  itemCount: reviewinfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(reviewinfo[index].useremail,
                            style: const TextStyle(fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),),
                        ),
                        const SizedBox(height: 5.0,),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(reviewinfo[index].detail),
                        ),
                        const SizedBox(height: 5.0,),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(reviewinfo[index].regdate),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext ctx, int idx) {
                    return Divider();
                  })
          );
        }
      });
  }

  Future<void> getReviewFirestoreData() async {
    print("getReviewFirestoreData Product ID = ${widget.proid}");
    reviewinfo = await firestore.collection("review").doc(widget.proid).collection('comment').get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Review.fromSnapshot(document);
      }).toList();
    });
  }
}
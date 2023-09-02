import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shoppingmallflutter/models/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmallflutter/screens/detail_screen.dart';
import 'package:shoppingmallflutter/widgets/grade_level.dart';

class TabHomeWidget extends StatefulWidget {
  const TabHomeWidget({super.key});

  @override
  State<TabHomeWidget> createState() => _TabHomeWidgetState();
}

class _TabHomeWidgetState extends State<TabHomeWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.fetchItems();

  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: productProvider.fetchItems(),
            builder: (context, snapshots) {
              if (productProvider.products.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // Expanded 를 추가하지 않으면 스크롤이 안되는 이슈와 Bottom overflowed 이슈가 발생된다.
                return Expanded(
                    child:GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.6,
                      ),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                          child: InkWell(
                            onTap: () {
                              openDetailItemScreen(productProvider.products[index].proid,
                                  productProvider.products[index].youtubeid);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child : CachedNetworkImage(
                                      imageUrl: productProvider.products[index].image,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    )
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    productProvider.products[index].title,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Text('${productProvider.products[index].price}원',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
                                  Text('${productProvider.products[index].discountprice}원 (${productProvider.products[index].discountrate}% 할인가)',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),),
                                  GradeLevelWidget(gradeLevel: productProvider.products[index].grade,),
                                ],
                              ),
                            ),
                          )
                      );
                    }
                )
                );
              }
            },
          )
        ],
      ),
    );
  }

  void openDetailItemScreen(String proid, String youtobeid) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
         DetailScreenPage(title: 'NOTI.MARKET', proid: proid, youtubeid: youtobeid,)), (route) => true);
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
import 'package:shoppingmallflutter/models/category_provider.dart';

class TabCategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: categoryProvider.fetchItems(),
            builder: (context, snapshots) {
              if (categoryProvider.categorys.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // Expanded 를 추가하지 않으면 스크롤이 안되는 이슈와 Bottom overflowed 이슈가 발생된다.
                return Expanded(child:GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.0 / 1.5,
                    ),
                    itemCount: categoryProvider.categorys.length,
                    itemBuilder: (context, index) {
                      return GridTile(
                          child: InkWell(
                            onTap: () { },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child : CachedNetworkImage(
                                      imageUrl: categoryProvider.categorys[index].img,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                  Center(
                                    child : Text(
                                      categoryProvider.categorys[index].categoryname,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    )
                                  )
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
}

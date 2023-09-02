import 'package:flutter/material.dart';
import 'package:shoppingmallflutter/screens/tabhome_screen.dart';
import 'package:shoppingmallflutter/screens/tabcategory_screen.dart';
import 'package:shoppingmallflutter/screens/tabcart_screen.dart';
import 'package:shoppingmallflutter/screens/tabprofile_screen.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key, required this.title});

  final String title;

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {

  @override
  void initState() {
    super.initState();
    print("HomeScreenPage initState in");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("HomeScreenPage didChangeDependencies in");
  }

  @override
  Widget build(BuildContext context) {
    print("HomeScreenPage build in");
    return DefaultTabController(
        initialIndex: 0,
        length: 4, // 탭의 수 설정
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Colors.black,
            // TabBar 구현, 각 content를 호출할 탭들을 등록
          ),
          bottomNavigationBar: Container(
            color: Colors.black, //색상
            child: const TabBar(
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.home, size: 20), height: 55,
                    child: Text(
                        "NOTI",
                        style: TextStyle(fontSize: 12)
                      )
                    ),
                  Tab(icon: Icon(Icons.category, size: 20), height: 55,
                      child: Text(
                          "카테고리",
                          style: TextStyle(fontSize: 12)
                      )
                  ),
                  Tab(icon: Icon(Icons.shopping_cart, size: 20), height: 55,
                      child: Text(
                          "장바구니",
                          style: TextStyle(fontSize: 12)
                      )
                  ),
                  Tab(icon: Icon(Icons.person_pin, size: 20), height: 55,
                      child: Text(
                          "나의노티",
                          style: TextStyle(fontSize: 12)
                      )
                  ),
                ],
            ),
          ),
          body: TabBarView(
            children: [
              TabHomeWidget(),
              TabCategoryWidget(),
              TabCartWidget(),
              TabProfileWidget(),
          ]
        )
      )
    );
  }
}


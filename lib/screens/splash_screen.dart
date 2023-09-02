import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingmallflutter/screens/home_screen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key, required this.title});

  final String title;

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    // 화면 로테이션이 없는 풀스크린 앱
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // 2초 보여주고 자동으로 종료되도록 처리됨
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        // 스플래시 스크린을 2초 보여주고 자동으로 HomeScreenPage를 호출 한다.
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) =>
            const HomeScreenPage(title: 'NOTI.MARKET')), (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
              )),
          Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset('images/logo_center.png'),
                color: Colors.white,
              ),),
          Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset('images/logo_bottom.png'),
                color: Colors.white,
              )),
        ],
      )
    );
  }
}

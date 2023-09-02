import 'package:flutter/material.dart';

class ReturnScreenPage extends StatefulWidget {
  const ReturnScreenPage({super.key, required this.title,});

  final String title;

  @override
  State<ReturnScreenPage> createState() => _ReturnScreenPageState();
}

class _ReturnScreenPageState extends State<ReturnScreenPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        body: const Center(
            child: Text("취소/반품/교환 물품이 없습니다.", style: TextStyle(fontSize: 15),),
          )
    );
  }
}

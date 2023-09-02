import 'package:flutter/material.dart';

class GradeLevelWidget extends StatefulWidget {
  const GradeLevelWidget({super.key, required this.gradeLevel});

  final int gradeLevel;

  @override
  State<GradeLevelWidget> createState() => _GradeLevelWidgetState();
}

class _GradeLevelWidgetState extends State<GradeLevelWidget> {

  List<String> selectPic = [
    "images/star1.png",
    "images/star2.png",
    "images/star3.png",
    "images/star4.png",
    "images/star5.png",
  ];

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
    return Image.asset(selectPic[widget.gradeLevel-1], width: 90, height: 30,);
  }
}
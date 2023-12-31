import 'package:flutter/material.dart';
import 'package:gs1_v2_project/utils/colors.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: darkBlue,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

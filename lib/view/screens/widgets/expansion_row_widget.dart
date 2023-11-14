// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ExpansionRowWidget extends StatelessWidget {
  String keyy;
  String value;
  double? fontSize;

  ExpansionRowWidget({
    super.key,
    required this.keyy,
    required this.value,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              keyy,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: fontSize ?? 10,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
            ),
          ),
          Expanded(child: Container()),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: fontSize ?? 10,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
            ),
          ),
        ],
      ),
    );
  }
}

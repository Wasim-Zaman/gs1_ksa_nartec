import 'package:flutter/material.dart';
import 'package:gs1_v2_project/utils/colors.dart';

class RequiredTextWidget extends StatelessWidget {
  const RequiredTextWidget({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title ?? "Title",
            style: const TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const TextSpan(
            text: '*',
            style: TextStyle(
              fontSize: 18,
              color: redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

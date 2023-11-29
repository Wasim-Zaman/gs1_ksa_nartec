import 'package:flutter/material.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String caption;
  final VoidCallback onPressed;
  final double? buttonWidth;
  final double? buttonHeight;
  const PrimaryButtonWidget(
      {Key? key,
      required this.caption,
      required this.onPressed,
      this.buttonWidth,
      this.buttonHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(caption),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(buttonWidth ?? 200, buttonHeight ?? 50),
      ),
    );
  }
}

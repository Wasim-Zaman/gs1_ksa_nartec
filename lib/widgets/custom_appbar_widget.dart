import 'package:flutter/material.dart';
import 'package:gs1_v2_project/utils/colors.dart';

AppBar customAppBarWidget({
  String? title,
  IconData? icon,
  List<Widget>? actions,
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  return AppBar(
    title: Text(
      title ?? "Retailer",
      softWrap: true,
    ),
    elevation: 0,
    foregroundColor: foregroundColor ?? whiteColor,
    backgroundColor: backgroundColor ?? yellowAppBarColor,
    // leading: Icon(
    //   icon ?? Icons.shopping_bag_outlined,
    // ),
    actions: actions ?? [],
  );
}

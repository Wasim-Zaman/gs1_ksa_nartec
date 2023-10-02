// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/view/screens/home/home_screen.dart';

AppBar HomeAppBarWidget(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.white,
    title: const Text('Home'),
    leading: IconButton(
      onPressed: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      icon: const Icon(
        Icons.home_outlined,
        size: 30,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/widgets/loading/loading_widget.dart';

class AppDialogs {
  static BuildContext? dialogueContext;
  static Future<dynamic> loadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogueContext = ctx;
        // return Container(
        //   color: AppColors.transparentColor,
        //   child: Center(
        //     child: SpinKitFadingCircle(
        //       color: AppColors.primaryColor,
        //       size: 30.0,
        //     ),
        //   ),
        // );
        return const LoadingWidget();
      },
    );
  }

  static void closeDialog() {
    Navigator.pop(dialogueContext!);
  }

  static bool exitDialog(BuildContext context) {
    bool? exitStatus = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              loadingDialog(context);
              exitStatus = await FlutterExitApp.exitApp();
              closeDialog();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return exitStatus ?? false;
  }

  static likeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('You liked this recipe'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  static chooseLanguage(BuildContext context) {
    // create a dialog with which to select the language
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('English'),
              value: 'en_US',
              groupValue: 'en_US',
              onChanged: (value) {
                // update language using getx
                Get.updateLocale(const Locale('en', 'US'));
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Arabic'),
              value: 'ar_SA',
              groupValue: 'en_US',
              onChanged: (value) {
                // update language using getx
                Get.updateLocale(const Locale('ar', 'SA'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

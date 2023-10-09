import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view/screens/qr_code_scanning_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});
  static const routeName = "/first_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GTIN Tracker V.2.0".tr),
        backgroundColor: darkBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              child: Image.asset('assets/images/gtrack.jpg'),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("GTIN Tracking".tr),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(QRCodeScanningScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

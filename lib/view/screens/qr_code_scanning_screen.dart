import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/constants/images/other_images.dart';
import 'package:gs1_v2_project/providers/gtin.dart';
import 'package:gs1_v2_project/utils/scan_code_utils.dart';
import 'package:gs1_v2_project/view/screens/product-tracking/gtin_reporter_screen.dart';
import 'package:gs1_v2_project/view/screens/regulatory_affairs_screen.dart';
import 'package:gs1_v2_project/view/screens/retail_information_screen.dart';
import 'package:gs1_v2_project/view/screens/retailor_shopper_screen.dart';
import 'package:gs1_v2_project/view/screens/verified-by-gs1/verify_by_gs1_screen.dart';
import 'package:gs1_v2_project/widgets/buttons/primary_button_widget.dart';
import 'package:gs1_v2_project/widgets/buttons/rectangular_text_button.dart';
import 'package:gs1_v2_project/widgets/custom_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

class QRCodeScanningScreen extends StatefulWidget {
  const QRCodeScanningScreen({Key? key}) : super(key: key);
  static const routeName = '/scanning-screen';

  @override
  State<QRCodeScanningScreen> createState() => _QRCodeScanningScreenState();
}

class _QRCodeScanningScreenState extends State<QRCodeScanningScreen> {
  late String cameraText;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String gtinCode = '';
  bool isStartScanning = false;

  TextEditingController gtinController = TextEditingController();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> scanCode() async {
    var scannedResult = await ScanCodeUtils.scanQRCode();

    gtinController.text = scannedResult;
    // Remove the special character from the scanned result
    scannedResult = scannedResult.replaceAll("", "");

    // Check if the barcode is 1D or 2D
    if (scannedResult.length < 15) {
      // It means it is 1D, no need to extract
      setState(() {
        gtinCode = scannedResult;
      });
    } else {
      // It means it is 2D, extract the GTIN
      setState(() {
        gtinCode = scannedResult.substring(2, 15);
      });
    }
  }

  navigate(String code) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final icon = args['icon'];

    // Navigate to the page based on the icon clicked
    /*
            * If icon is product-contents then navigate to RetailorShopperDetailScreen
            * If icon is retail-information then navigate to RetailInformationScreen 
            * if icon is regulatory-affairs then navigate to RegulatoryAffairsScreen
            * If icon is gtin-reporter then navigate to GtinReporterScreen 

          */

    if (icon == 'product-contents') {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        RetailorShopperScreen.routeName,
        arguments: code,
      );
    }
    if (icon == 'retail-information') {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        RetailInformationScreen.routeName,
        arguments: code,
      );
    }

    if (icon == "gtin-reporter") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        GtinReporterScreen.routeName,
        arguments: code,
      );
    }
    if (icon == "verified-by-gs1") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        VerifyByGS1Screen.routeName,
        arguments: code,
      );
    }

    if (icon == "regulatory-affairs") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        RegulatoryAffairsScreen.routeName,
        arguments: code,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final icon = args['icon'];
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
              AppColors.backgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(OtherImages.trans_logo),
              30.heightBox,
              if (icon == 'product-contents')
                customAppBarWidget(
                  title: 'Product Contents'.tr,
                  icon: Icons.shopping_bag_outlined,
                  backgroundColor: Colors.deepOrange,
                ),
              if (icon == 'retail-information')
                customAppBarWidget(
                    title: 'Retail Information'.tr,
                    icon: Icons.shopping_bag_outlined,
                    backgroundColor: Colors.green[800]),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Scan QR Code from your device's camera"
                        .tr
                        .text
                        .color(AppColors.primaryColor)
                        .xl
                        .make()
                        .centered(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RectangularTextButton(
                          onPressed: () {
                            setState(() {
                              gtinCode = '';
                            });
                          },
                          caption: "RESET".tr,
                          buttonHeight: context.height * 0.05,
                        ),
                        RectangularTextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          caption: "PREVIOUS PAGE".tr,
                          buttonHeight: context.height * 0.05,
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    "Ready - Click START to scan"
                        .tr
                        .text
                        .xl
                        .color(AppColors.primaryColor)
                        .make()
                        .centered(),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PrimaryButtonWidget(
                          caption: 'START'.tr,
                          onPressed: scanCode,
                        ).box.make().centered(),
                        PrimaryButtonWidget(
                          caption: 'VISIT'.tr,
                          onPressed: () {
                            if (gtinCode == "") {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Kindly scan QR Code')),
                              );
                            } else
                              navigate(gtinCode);
                          },
                        ).box.make().centered(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      gtinCode == "" ? "No Code Scanned" : gtinController.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ).box.make().p12().centered(),
                    const SizedBox(height: 30),
                    Text(gtinCode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

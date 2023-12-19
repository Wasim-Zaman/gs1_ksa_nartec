import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/constants/images/other_images.dart';
import 'package:gs1_v2_project/global/variables/global_variables.dart';
import 'package:gs1_v2_project/providers/gtin.dart';
import 'package:gs1_v2_project/utils/app_navigator.dart';
import 'package:gs1_v2_project/utils/scan_code_utils.dart';
import 'package:gs1_v2_project/view/screens/product-tracking/gtin_reporter_screen.dart';
import 'package:gs1_v2_project/view/screens/regulatory_affairs_screen.dart';
import 'package:gs1_v2_project/view/screens/retail_information_screen.dart';
import 'package:gs1_v2_project/view/screens/retailor_shopper_screen.dart';
import 'package:gs1_v2_project/view/screens/scanning/barcode_scanning_screen.dart';
import 'package:gs1_v2_project/view/screens/verified-by-gs1/verify_by_gs1_screen.dart';
import 'package:gs1_v2_project/widgets/buttons/primary_button_widget.dart';
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
  String? gtinCode;
  String? icon;
  bool isStartScanning = false;

  TextEditingController gtinController = TextEditingController();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String extractGTINFromBarcode(String barcodeData) {
    // Remove any non-numeric characters
    String cleanedBarcode = barcodeData.replaceAll(RegExp(r'[^0-9]'), '');

    // Check the barcode type to determine the GTIN pattern
    // For example, if you're using EAN-13 format:
    if (cleanedBarcode.length == 13) {
      // GS1 Company Prefix: first 7 digits
      String companyPrefix = cleanedBarcode.substring(1, 7);

      // Item Reference: next 5 digits
      String itemReference = cleanedBarcode.substring(7, 12);

      // The complete GTIN is the concatenation of the Company Prefix and Item Reference
      String gtin = '$companyPrefix$itemReference';

      return gtin;
    }

    // Handle other barcode types or return null if it doesn't match any pattern
    return "";
  }

  Future<void> scanCode() async {
    var scannedResult = await ScanCodeUtils.scanQRCode();

    gtinController.text = scannedResult;
    // Remove the special character from the scanned result
    scannedResult = scannedResult.replaceAll("", "");

    if (scannedResult.startsWith("01") && scannedResult.length > 15) {}

    // Check if the barcode is 1D or 2D
    if (scannedResult.length < 15) {
      // It means it is 1D, no need to extract
      setState(() {
        gtinCode = scannedResult.substring(0, 12);
      });
    } else {
      // It means it is 2D, extract the GTIN
      setState(() {
        gtinCode = scannedResult.substring(2, 15);
      });
    }

    if (gtinCode == "") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kindly scan QR Code')),
      );
    } else if (gtinController.text.length > 15 &&
        !gtinController.text.startsWith("01")) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Barcode')),
      );
    } else
      navigate();
  }

  navigate() {
    var barcodeValue = GlobalVariables.barcodeValue.text;
    var codeType = GlobalVariables.barcodeType.text;
    gtinCode = extractGtin(barcodeValue, codeType);

    if (gtinCode == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Barcode')),
      );
      return;
    }
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    icon = args['icon'];

    // Navigate to the page based on the icon clicked
    /*
            * If icon is product-contents then navigate to RetailorShopperDetailScreen
            * If icon is retail-information then navigate to RetailInformationScreen 
            * if icon is regulatory-affairs then navigate to RegulatoryAffairsScreen
            * If icon is gtin-reporter then navigate to GtinReporterScreen 

          */

    if (icon == 'product-contents') {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushReplacementNamed(
        RetailorShopperScreen.routeName,
        arguments: gtinCode,
      );
    }
    if (icon == 'retail-information') {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        RetailInformationScreen.routeName,
        arguments: gtinCode,
      );
    }

    if (icon == "gtin-reporter") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        GtinReporterScreen.routeName,
        arguments: gtinCode,
      );
    }
    if (icon == "verified-by-gs1") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        VerifyByGS1Screen.routeName,
        arguments: gtinCode,
      );
    }

    if (icon == "regulatory-affairs") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushNamed(
        RegulatoryAffairsScreen.routeName,
        arguments: gtinCode,
      );
    }
  }

  String? extractGtin(String scannedCode, String codeType) {
    if (codeType == 'ean13') {
      return scannedCode;
    } else if (codeType.toLowerCase() == 'datamatrix') {
      print(codeType);
      print(scannedCode);
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(scannedCode);
      print(result);

      RegExp gtinPattern = RegExp(r'01 \(GTIN\): (\d+)');

      Match? match = gtinPattern.firstMatch(result.toString());
      if (match != null) {
        String gtin = match.group(1)!;
        return gtin;
      } else {
        return null;
      }

      // extract gtin from result
    }
    // if (codeType.toLowerCase() == 'datamatrix') {
    //   scannedCode = scannedCode..replaceAll("", "");
    //   GlobalVariables.barcodeValue.text =
    //       extractGTINFromGS1DataMatrix(scannedCode) ?? "";
    //   return extractGTINFromGS1DataMatrix(scannedCode);
    // }
    return null;
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
                    const SizedBox(height: 50),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     RectangularTextButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           gtinCode = '';
                    //         });
                    //       },
                    //       caption: "RESET".tr,
                    //       buttonHeight: context.height * 0.05,
                    //     ),
                    //     RectangularTextButton(
                    //       onPressed: () {
                    //         Navigator.of(context).pop();
                    //       },
                    //       caption: "PREVIOUS PAGE".tr,
                    //       buttonHeight: context.height * 0.05,
                    //     ),
                    //   ],
                    // ),
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
                          onPressed: () {
                            AppNavigator.goToPage(
                              context: context,
                              screen: BarcodeScanningScreen(
                                icon: icon.toString(),
                              ),
                            );
                          },
                        ),
                        // PrimaryButtonWidget(
                        //   caption: 'VISIT'.tr,
                        //   onPressed: navigate,
                        // ).box.make().centered(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      GlobalVariables.barcodeValue.text == ""
                          ? "No Code Scanned"
                          : GlobalVariables.barcodeValue.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ).box.make().p12().centered(),
                    Text(
                      GlobalVariables.barcodeType.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ).box.make().p12().centered(),
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

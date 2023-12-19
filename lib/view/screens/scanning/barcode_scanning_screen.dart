import 'package:flutter/material.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:gs1_v2_project/global/variables/global_variables.dart';
import 'package:gs1_v2_project/providers/gtin.dart';
import 'package:gs1_v2_project/view/screens/product-tracking/gtin_reporter_screen.dart';
import 'package:gs1_v2_project/view/screens/regulatory_affairs_screen.dart';
import 'package:gs1_v2_project/view/screens/retail_information_screen.dart';
import 'package:gs1_v2_project/view/screens/retailor_shopper_screen.dart';
import 'package:gs1_v2_project/view/screens/verified-by-gs1/verify_by_gs1_screen.dart';
import 'package:native_barcode_scanner/barcode_scanner.dart';
import 'package:provider/provider.dart';

class BarcodeScanningScreen extends StatefulWidget {
  final String icon;
  const BarcodeScanningScreen({Key? key, required this.icon}) : super(key: key);

  @override
  State<BarcodeScanningScreen> createState() => _BarcodeScanningScreenState();
}

class _BarcodeScanningScreenState extends State<BarcodeScanningScreen> {
  @override
  void dispose() {
    // close scanning | camera
    BarcodeScanner.stopScanner();

    super.dispose();
  }

  navigate() {
    var barcodeValue = GlobalVariables.barcodeValue.text;
    var codeType = GlobalVariables.barcodeType.text;
    String? gtinCode = extractGtin(barcodeValue, codeType);

    if (gtinCode == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Barcode')),
      );
      return;
    }

    final icon = widget.icon;

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
      Navigator.of(context).pushReplacementNamed(
        RetailInformationScreen.routeName,
        arguments: gtinCode,
      );
    }

    if (icon == "gtin-reporter") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushReplacementNamed(
        GtinReporterScreen.routeName,
        arguments: gtinCode,
      );
    }
    if (icon == "verified-by-gs1") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushReplacementNamed(
        VerifyByGS1Screen.routeName,
        arguments: gtinCode,
      );
    }

    if (icon == "regulatory-affairs") {
      Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
      Navigator.of(context).pushReplacementNamed(
        RegulatoryAffairsScreen.routeName,
        arguments: gtinCode,
      );
    }
  }

  String? extractGtin(String scannedCode, String codeType) {
    if (codeType == 'ean13') {
      String cleanedBarcode = scannedCode.replaceAll(RegExp(r'[^0-9]'), '');
      return cleanedBarcode;
    } else if (codeType.toLowerCase() == 'datamatrix') {
      print(codeType);
      print(scannedCode);
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(scannedCode);
      // print(result);

      RegExp gtinPattern = RegExp(r'01 \(GTIN\): (\d+)');

      Match? match = gtinPattern.firstMatch(result.toString());
      if (match != null) {
        String gtin = match.group(1)!;
        // if gtin is 14 digits, remove the first digit
        if (gtin.length == 14) {
          gtin = gtin.substring(1);
        }
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
    return Scaffold(
      appBar: AppBar(),
      body: BarcodeScannerWidget(
        startScanning: true,
        stopScanOnBarcodeDetected: true,
        onTextDetected: (textResult) {},
        scannerType: ScannerType.barcode,
        onBarcodeDetected: (barcode) {
          print(barcode.format.name);
          GlobalVariables.barcodeType.text = barcode.format.name;
          GlobalVariables.barcodeValue.text = barcode.value;
          navigate();
        },
        onError: (error) {
          print('Error reading barcode: $error');
        },
      ),
    );
  }
}

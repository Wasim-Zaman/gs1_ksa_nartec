// import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanCodeUtils {
  static Future<String> scanQRCode() async {
    String barcodeScanResult;
    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );
      return barcodeScanResult;
    } catch (_) {
      rethrow;
    }
  }
}

// class ScanCodeUtils {
//   static Future<String> getBarcode() async {
//     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         COLOR_CODE, CANCEL_BUTTON_TEXT, isShowFlashIcon, scanMode);
//     return barcodeScanRes;
//   }
// }

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  final String data;
  const QRImage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: data,
        size: 100,
        // You can include embeddedImageStyle Property if you
        //wanna embed an image from your Asset folder
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(
            100,
            100,
          ),
        ),
      ),
    );
  }
}

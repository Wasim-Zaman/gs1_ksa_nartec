import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 150,
      width: 100,
      child: (imageUrl.isEmptyOrNull)
          ? Icon(
              Icons.image_outlined,
              size: 60,
            )
          : Image.network(
              imageUrl.toString(),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_outlined,
                size: 60,
              ),
            ),
    );
  }
}

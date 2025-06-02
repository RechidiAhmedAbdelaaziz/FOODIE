import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final ImageProvider image;

  final double width;
  final double height;
  final double borderRadius;

  const ImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
    );
  }
}

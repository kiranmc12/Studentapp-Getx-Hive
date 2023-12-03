import 'dart:io';

import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  final double radius;
  final String? image;
  const CircleImageWidget({
    super.key,
    required this.radius, 
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: radius,
      backgroundImage: FileImage(File(image!))
    );
  }
}
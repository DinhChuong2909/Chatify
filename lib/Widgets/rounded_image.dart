import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RoundedImageNetwork extends StatelessWidget {
  final String imgPath;
  final double size;

  const RoundedImageNetwork({ // Constructor
    required Key key,
    required this.imgPath,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(imgPath)),
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        color: Colors.black,
      ),
    );
  }
}

class RoundedImageFile extends StatelessWidget {
  final PlatformFile image;
  final double size;

  const RoundedImageFile({
    required Key key,
    required this.image,
    required this.size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(image.path!)),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        color: Colors.black,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/rounded_image.dart';

class CustomPersonTile extends StatelessWidget {
  final double height;
  final double width;
  final String name;
  final String imgUrl;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  const CustomPersonTile({
    super.key,
    required this.height,
    required this.width,
    required this.name,
    required this.imgUrl,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            )
          : null,
      onTap: () => onTap(),
      leading: RoundedImageNetworkWithStatus(
        imgPath: imgUrl,
        size: height * 0.05,
        isActive: isActive,
        key: UniqueKey(),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

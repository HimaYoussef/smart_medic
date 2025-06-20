import 'package:flutter/material.dart';
import '../utils/Colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      this.onTap,
      this.height = 50,
      this.radius = 5,
      this.style,
      this.color = const Color(0xFFAF4F41),
      this.width = double.infinity});

  final String text;
  final void Function()? onTap;
  final double height;
  final double width;
  final double radius;
  final Color color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius)),
        child: Text(
          text,
          style: style ??
              TextStyle(
                  color: AppColors.scaffoldBG, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
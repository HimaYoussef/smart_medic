import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.text, this.onTap, this.height = 50, required int width, required int radius});

  final String text;
  final void Function()? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.color1, borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: TextStyle(
              color: AppColors.scaffoldBG, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
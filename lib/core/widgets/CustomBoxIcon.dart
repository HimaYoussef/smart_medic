import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class CustomBoxIcon extends StatelessWidget {
  const CustomBoxIcon({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.add, size: 50, color: AppColors.color1),
          onPressed: onTap,
        ),
      ),
    );
  }
}

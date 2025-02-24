import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class CustomBoxIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double iconSize; // Added iconSize parameter

  const CustomBoxIcon({super.key, required this.onTap, this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: iconSize, // Bigger plus (+) icon
            color: AppColors.color1,
          ),
        ),
      ),
    );
  }
}

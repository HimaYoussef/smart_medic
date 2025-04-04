import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';

import '../../Features/Users/Patient/Home/Widgets/Refill_Medicine.dart';

class CustomBoxFilled extends StatelessWidget {
  const CustomBoxFilled({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey
            : AppColors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.ShadowColor,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.replay_circle_filled_rounded), color: Colors.black26,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Refill_Medicine()));

                  },),
                IconButton(icon:const Icon(Icons.edit_rounded), color: Colors.black26, onPressed: () { },),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Paracetamol', // No onTap, now it's just text
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

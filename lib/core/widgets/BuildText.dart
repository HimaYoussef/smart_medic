import 'package:flutter/cupertino.dart';
import '../../../../../../core/utils/Colors.dart';
import '../../../../../../core/utils/Style.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fonSize;
  const CustomText({
    super.key, required this.text, required this.fonSize
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTitleStyle(
        fontSize: fonSize,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }
}
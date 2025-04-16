import 'package:flutter/material.dart';
import '../../../../../../core/functions/email_validation.dart';
import '../../../../../../core/utils/Colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? validatorText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool? enablation;
  final Function(String)? onChanged;
  final int? maxValue;

  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.keyboardType,
    required this.readOnly,
    this.validatorText,
    this.enablation,
    this.onChanged,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enablation,
      textAlign: TextAlign.start,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: labelText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validatorText;
        }
        else if (keyboardType==TextInputType.emailAddress && !emailValidate(value)) {
          return 'Please Enter A valid email';
        }
        else if(labelText=='Please Enter Your Age'&&(int.tryParse(value) == null || int.parse(value) <= 0)){
          return 'Please Enter a valid Age';
        };

        if (maxValue != null && keyboardType == TextInputType.number) {
          int? parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue > maxValue!) {
            return 'Value must be less than or equal to $maxValue';
          }
          if (parsedValue <= 0) {
            return 'Value must be greater than 0';
          }
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
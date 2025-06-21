import 'package:flutter/material.dart';
import 'package:smart_medic/generated/l10n.dart';
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
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction; // Added
  final Function(String)? onFieldSubmitted; // Added

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
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction, // Added
    this.onFieldSubmitted, // Added
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enablation,
      textAlign: TextAlign.start,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      textInputAction: textInputAction, // Use provided or default
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: labelText,
        suffixIcon: suffixIcon,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validatorText;
        }
        if (keyboardType == TextInputType.emailAddress && !emailValidate(value)) {
          return  S.of(context).build_text_field_validatorText1;
        }
        if (obscureText && value.length < 6) {
          return  S.of(context).build_text_field_validatorText2;
        }
        if (labelText ==  S.of(context).build_text_field_validatorText4 && (int.tryParse(value) == null || int.parse(value) <= 12 || int.parse(value) > 99)) {
          return  S.of(context).build_text_field_validatorText5;
        }
        if (maxValue != null && keyboardType == TextInputType.number) {
          int? parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue > maxValue!) {
            return 'Value must be less than or equal to $maxValue';
          }
          if (parsedValue <= 0) {
            return  S.of(context).build_text_field_validatorText6;
          }
        }
        return null;
      },
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted, // Use the provided callback
    );
  }
}
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Get the button style from the theme
    final buttonStyle = Theme.of(context).elevatedButtonTheme.style;

    // Resolve the MaterialStateProperty to get the actual TextStyle
    final textStyle = buttonStyle?.textStyle?.resolve({WidgetState.pressed});

    return SizedBox(
      width: 339,
      height: 49,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,  // Apply the button style from the theme
        child: Text(
          text,
          style: textStyle,  // Use the resolved TextStyle
        ),
      ),
    );
  }
}
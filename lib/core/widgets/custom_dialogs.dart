// error

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showErrorDialog(context, errorText) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(10),
      content: Text(errorText)));
}

// loading
showLoadingDialog(BuildContext context) {
  //------------ Using Custom Loading for IOS & Android

  showDialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.7),
    context: context,
    builder: (BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/Health.json',
            width: 250,
            height: 250,
          ),
        ],
      );
    },
  );
}
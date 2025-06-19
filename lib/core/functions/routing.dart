import 'package:flutter/material.dart';

pushTo(BuildContext context, Widget newView) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => newView,
  ));
}

pushToWithReplacement(BuildContext context, Widget newView) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => newView,
  ));
}

pushAndRemoveUntil(BuildContext context, Widget newView) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => newView,
      ),
      (Route) => false);
}

Pop(BuildContext context, Widget newView) {
  Navigator.pop(context);
}
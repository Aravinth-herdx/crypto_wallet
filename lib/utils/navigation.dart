import 'package:flutter/material.dart';

void navigateToReplace(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => screen),
  );
}

import 'package:flutter/material.dart';

class ScreenAppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:'logo',
      child: Image.asset(
        'images/comperio-logo.png',
        height: 70.0,
        width: 70.0,
      ),
    );
  }
}

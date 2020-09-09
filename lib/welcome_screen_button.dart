import 'package:flutter/material.dart';

class WelcomeScreenButtons extends StatelessWidget {
  final String buttonText;
  final String redirectionScreen;
  final Color colour;

  WelcomeScreenButtons({this.buttonText, this.redirectionScreen, this.colour});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 350.0,
      child: RaisedButton(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: () {
          Navigator.pushNamed(context, redirectionScreen);
        },
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        color: colour,
        textColor: Colors.white,
        child: Text(
          buttonText.toUpperCase(),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

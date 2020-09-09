import 'package:comperio/constants.dart';
import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
import 'package:comperio/welcome_screen_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String id = 'WelcomeScreen';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        image: DecorationImage(
          image: AssetImage('images/welcome-page-bg1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                        'images/comperio-logo.png',
                      ),
                      height: 110.0,
                      width: 110.0,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: Text(
                        'Welcome to',
                        style: KWelcomeTextStyle,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Comperio!',
                        style: KWelcomeTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    WelcomeScreenButtons(
                        buttonText: 'Login',
                        redirectionScreen: LoginScreen().id,
                        colour: Color(0xff5e35b1)),
                    SizedBox(
                      height: 30.0,
                    ),
                    WelcomeScreenButtons(
                        buttonText: 'Register',
                        redirectionScreen: RegistrationScreen().id,
                        colour: Color(0xff311b92)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

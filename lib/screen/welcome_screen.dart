import 'package:comperio/constants.dart';
import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
import 'package:comperio/welcome_screen_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});

    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
//        color: Color(0xFF11CBD6),
      color:Colors.white,
        image: DecorationImage(

          image: AssetImage('images/WelcomeScreen3.jpg'),
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
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: controller.value * 100,

                        child: Image(
                          image: AssetImage(
                            'images/comperio-logo.png',
                          ),
                          height: 110.0,
                          width: 110.0,
                        ),
                      ),
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
                      height: 90.0,
                    ),
                    WelcomeScreenButtons(
                      buttonText: 'Login',

                      redirectionScreen: LoginScreen().id,

                      colour: Colors.blue,
//                  colour:Colors.blue.withOpacity(controller.value),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    WelcomeScreenButtons(
                        buttonText: 'Register',
                        redirectionScreen: RegistrationScreen().id,
                        colour: Color(0xff311b92)
//                     colour: Color(0xFF016FC4).withOpacity(controller.value),
                    ),
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







import 'package:comperio/constants.dart';
import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
import 'package:comperio/welcome_screen_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => SystemNavigator.pop(),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
      ),
    );
  }
}

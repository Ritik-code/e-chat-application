import 'package:comperio/constants.dart';
import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  final String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController controller1;
  AnimationController controller2;

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

    controller1 = AnimationController(
      duration: Duration(milliseconds: 50),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    controller1.addListener(() {
      setState(() {});
    });

    controller2 = AnimationController(
      duration: Duration(milliseconds: 50),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    controller2.dispose();
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
    double scale1 = 1 + controller1.value;
    double scale2 = 1 + controller2.value;

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
                      ButtonTheme(
                        minWidth: 300.0,
                        child: GestureDetector(
                          onTapDown: onTapDown1,
                          onTapUp: onTapUp1,
                          onTapCancel: onTapCancel1,
                          child: Transform.scale(
                            scale: scale1,
                            child: RaisedButton(
                              elevation: 10.0,
                              // splashColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, LoginScreen().id);
                              },
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                'Login'.toUpperCase(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ButtonTheme(
                        minWidth: 300.0,
                        child: GestureDetector(
                          onTapDown: onTapDown2,
                          onTapUp: onTapUp2,
                          onTapCancel: onTapCancel2,
                          child: Transform.scale(
                            scale: scale2,
                            child: RaisedButton(
                              elevation: 10.0,
                              // splashColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RegistrationScreen().id);
                              },
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              color: Color(0xff311b92),
                              textColor: Colors.white,
                              child: Text(
                                'Register'.toUpperCase(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
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

  onTapUp1(TapUpDetails details) {
    controller1.reverse();
  }

  onTapDown1(TapDownDetails details) {
    controller1.forward();
  }

  onTapCancel1() {
    controller1.reverse();
  }

  onTapUp2(TapUpDetails details) {
    controller2.reverse();
  }

  onTapDown2(TapDownDetails details) {
    controller2.forward();
  }

  onTapCancel2() {
    controller2.reverse();
  }
}

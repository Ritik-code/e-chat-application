import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
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
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        'welcome to'.toUpperCase(),
                        style: TextStyle(
                          color: Color(0xFFB2EBF2),
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'comperio!'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    ButtonTheme(
                      minWidth: 350.0,
                      child: RaisedButton(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        color: Color(0xff5e35b1),
                        textColor: Colors.white,
                        child: Text(
                          'Login'.toUpperCase(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ButtonTheme(
                      minWidth: 350.0,
                      child: RaisedButton(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                          );
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

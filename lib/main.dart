import 'package:comperio/screen/chat_screen.dart';
import 'package:comperio/screen/feedback_screen.dart';
import 'package:comperio/screen/welcome_screen.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Comperio());
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                WelcomeScreen()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(130.0),
      color: Colors.white,
      child: Image.asset('images/comperio-logo.png'),

    );
  }
}


class Comperio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      // initialRoute: WelcomeScreen().id,
      // routes: {
      //   ChatScreen().id: (context) => ChatScreen(),
      //   RegistrationScreen().id: (context) => RegistrationScreen(),
      //   LoginScreen().id: (context) => LoginScreen(),
      //   WelcomeScreen().id : (context) => WelcomeScreen(),
      //   'FeedbackScreen': (context) => FeedbackScreen(),
      //   ContactedPersonScreen().id: (context) => ContactedPersonScreen(),
      //
      // },
    );
  }
}


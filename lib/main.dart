import 'package:comperio/screen/change_password_screen.dart';
import 'package:comperio/screen/chat_screen.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:comperio/screen/feedback_screen.dart';
import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/profile_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
import 'package:comperio/screen/searchScreen.dart';
import 'package:comperio/screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Comperio());
}

class Comperio extends StatefulWidget {
  @override
  _ComperioState createState() => _ComperioState();
}

class _ComperioState extends State<Comperio> {
  bool userIsLoggedIn = true;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    bool value = await HelperFunctions.getUserLoggedInSharedPreference();
    setState(() {
      userIsLoggedIn = value;
    });
    print(userIsLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userIsLoggedIn != null
          ? userIsLoggedIn ? ContactedPersonScreen() : WelcomeScreen()
          : WelcomeScreen(),
      // initialRoute: ,
      routes: {
        ChatScreen().id: (context) => ChatScreen(),
        RegistrationScreen().id: (context) => RegistrationScreen(),
        LoginScreen().id: (context) => LoginScreen(),
        WelcomeScreen().id: (context) => WelcomeScreen(),
        FeedbackScreen().id: (context) => FeedbackScreen(),
        ContactedPersonScreen().id: (context) => ContactedPersonScreen(),
        SearchScreen().id: (context) => SearchScreen(),
        ProfileScreen().id: (context) => ProfileScreen(),
        ChangePasswordScreen().id: (context) => ChangePasswordScreen(),
      },
    );
  }
}

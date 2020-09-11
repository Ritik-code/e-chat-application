import 'package:comperio/screen/chat_screen.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:comperio/screen/feedback_screen.dart';
import 'package:comperio/screen/login_screen.dart';
import 'package:comperio/screen/registration_screen.dart';
import 'package:comperio/screen/searchScreen.dart';
import 'package:comperio/screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Comperio());
}

class Comperio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ChatScreen().id,
      routes: {
        ChatScreen().id: (context) => ChatScreen(),
        RegistrationScreen().id: (context) => RegistrationScreen(),
        LoginScreen().id: (context) => LoginScreen(),
        WelcomeScreen().id: (context) => WelcomeScreen(),
        FeedbackScreen().id: (context) => FeedbackScreen(),
        ContactedPersonScreen().id: (context) => ContactedPersonScreen(),
        SearchScreen().id: (context) => SearchScreen(),
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  final String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/app-background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'images/comperio-logo.png',
                      height: 70.0,
                      width: 70.0,
                    ),
                    Text(
                      'Comperio',
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 25, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'New',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: 'Enter your Email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Email *',
                                ),
                                onChanged: (String value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                  email = value;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: 'Enter Username',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Username *',
                                ),
                                onChanged: (String value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                  username = value;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.lock),
                                  hintText: 'Enter the password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Password *',
                                ),
                                obscureText: true,
                                onChanged: (String value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                  password = value;
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                ),
                                child: RaisedButton(
                                  elevation: 10.0,
                                  shape: StadiumBorder(),
                                  color: Colors.lightBlueAccent,
                                  onPressed: () async {
                                    try {
                                      final newUser = await _auth
                                          .createUserWithEmailAndPassword(
                                              email: email, password: password);
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc()
                                          .set({'username': username});
                                        FirebaseFirestore.instance.collection('users').getDocuments().then((querySnapshot) {
                                          querySnapshot.documents.forEach((result) {
                                            print(result.data);
                                          });
                                        });
                                      if (newUser != null) {
                                        Navigator.pushNamed(
                                            context, ContactedPersonScreen().id);
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 60.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
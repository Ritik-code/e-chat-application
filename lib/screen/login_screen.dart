import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:comperio/checkInternet.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/regexValidator.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:comperio/screen_app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rich_alert/rich_alert.dart';

import '../helper_functions.dart';

class LoginScreen extends StatefulWidget {
  final String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    CheckInternet().checkConnection(context);
  }

  @override
  void dispose() {
    CheckInternet().listener.cancel();
    super.dispose();
  }

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are  _autoValidate = true;correct then save data to out variables
      _formKey.currentState.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {});
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        image: DecorationImage(
          image: AssetImage('images/app-background-2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ScreenAppLogo(),
                      Text(
                        'Comperio',
                        style: KAppNameTextStyle,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
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
                          left: 16.0, right: 16.0, top: 35, bottom: 16.0),
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Welcome',
                                style: KCardTextStyle,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Back',
                                style: KCardTextStyle,
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'Enter the Email',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        labelText: 'Email *',
                                      ),
                                      validator: RegexValidator.validateEmail,
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                        email = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 30.0,
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
                                      validator:
                                          RegexValidator.validatePassword,
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                        password = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 50.0,
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
                                          CheckInternet()
                                              .checkConnection(context);
                                          bool isShowSpinner =
                                              _validateInputs();
                                          setState(() {
                                            showSpinner = isShowSpinner;
                                          });
                                          try {
                                            CheckInternet()
                                                .checkConnection(context);
                                            await _auth
                                                .signInWithEmailAndPassword(
                                                    email: email,
                                                    password: password)
                                                .then((newUser) async {
                                              if (newUser != null) {
                                                var userInfoSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .where('email',
                                                            isEqualTo: email)
                                                        .get()
                                                        .catchError((e) {
                                                  print(e.toString());
                                                });

                                                HelperFunctions
                                                    .saveUserLoggedInSharedPreference(
                                                        true);
                                                HelperFunctions
                                                    .saveUserNameSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .get('username'));
                                                HelperFunctions
                                                    .saveUserEmailSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .get('email'));
                                                HelperFunctions
                                                    .saveUserPhotoUrlSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .get('profileURL'));

                                                HelperFunctions
                                                    .saveUserRoleSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .get('role'));

                                                Navigator.pushNamed(context,
                                                    ContactedPersonScreen().id);
                                              }
                                            });
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          } catch (e) {
                                            print(e.message);
                                            if (e.message ==
                                                    "The password is invalid or the user does not have a password." ||
                                                e.message ==
                                                    "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                              setState(() {
                                                showSpinner = false;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return RichAlertDialog(
                                                      //uses the custom alert dialog
                                                      alertTitle: richTitle(
                                                          "Try Again"),
                                                      alertSubtitle: richSubtitle(
                                                          "Wrong email address or password."),
                                                      alertType:
                                                          RichAlertType.WARNING,
                                                      actions: <Widget>[
                                                        RaisedButton(
                                                          color: Colors.red,
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Log in',
                                          style: KLoginRegistrationButtonStyle,
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

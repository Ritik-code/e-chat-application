import 'package:commons/commons.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/regexValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String id = 'ChangePasswordScreen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  bool _autoValidate = false;
  String newPassword;
  String oldPassword;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //this method created to show dialogs
  void _showDialog({String text}) {
    warningDialog(
      context,
      text,
      neutralText: "Okay",
    );
  }

  //change the password
  void changePassword(String password) async {
    var user = await _auth.currentUser;
    validateUserPassword(oldPassword).then((_) {
      user.updatePassword(password).then((_) {
        //this method updating the password
        // _showDialog(
        //   text: 'Password Changed Successfully!!!',
        // );
        successDialog(context, 'Password Changed Successfully!!!',
            neutralText: 'Okay');
        setState(() {
          showSpinner = false;
        });
      }).catchError((e) {
        //catching error for updatedPassword
        print(e);
        // _showDialog(
        //   text: 'Password Not Changed!!!',
        // );
        warningDialog(
          context,
          'Password Not Changed!!!',
          neutralText: "Okay",
        );
      });
    }).catchError((onError) {
      //catching error for validateUserPassword
      print(onError);
      // _showDialog(
      //   text: 'Wrong Password!!!',
      // );
      warningDialog(
        context,
        'Wrong Password!!!',
        neutralText: "Okay",
      );
      setState(() {
        showSpinner = false;
      });
    });
  }

  //checking the old password
  validateUserPassword(String password) async {
    var firebaseUser = await _auth.currentUser;

    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser.email, password: password);

    return firebaseUser.reauthenticateWithCredential(authCredentials);
  }

  //validating form inputs

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg_p_image.jpg"), fit: BoxFit.cover),
          ),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autofocus: false,
                  cursorColor: Colors.white,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(color: Colors.white12, fontSize: 18.0),
                    labelText: 'Old Password *',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    oldPassword = value;
                    //check password entered is of same user with which is it is loggedIn.
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  cursorColor: Colors.white,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(color: Colors.white12, fontSize: 18.0),
                    labelText: 'New Password *',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: RegexValidator.validatePassword,
                  onChanged: (value) {
                    newPassword = value;
                    //take the value in a variable so that it can be updated.
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(15.0),
                    color: Colors.lightBlueAccent,
                    child: Text('Change Password',
                        style: KLoginRegistrationButtonStyle),
                    onPressed: () {
                      bool isShowSpinner = _validateInputs();
                      setState(() {
                        showSpinner = isShowSpinner;
                      });

                      if (newPassword == oldPassword) {
                        //condition if both the password are same
                        // _showDialog(
                        //   text: 'Password is same as old password!!!',
                        // );
                        warningDialog(
                          context,
                          'Password is same as old password!!!',
                          neutralText: "Okay",
                        );
                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        changePassword(newPassword);
                        setState(() {
                          showSpinner = isShowSpinner;
                        });
                      }

                      print('password changed');
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

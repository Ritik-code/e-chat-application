import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comperio/constants.dart';


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
  var validateOldPassword;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  String validatePassword(String value) {
    Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Password, include letters and numbers';
    else
      return null;
  }

//check for current password when user wants to change password
  Future<void> validateUserPassword(String password) async {
    var firebaseUser = await _auth.currentUser;

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      print(authResult.user);
        validateOldPassword =  authResult.user;

    } catch (e) {
      print(e);
    }
  }
  String validateUserOldPassword(String Value){
    if(validateOldPassword!=null ){
      return 'Wrong Password';
    }
    else{
      return null;
    }
  }
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "images/bg_p_image.jpg"),
                fit: BoxFit.cover),
        ),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: validateUserOldPassword,
                autofocus: false,
                cursorColor: Colors.white,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(
                      color: Colors.white12,
                      fontSize: 18.0
                  ),
                  labelText: 'Old Password *',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),

                onChanged: (value) async {
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
                  hintStyle: TextStyle(
                    color: Colors.white12,
                    fontSize: 18.0
                  ),
                  labelText: 'New Password *',
                  labelStyle: TextStyle(color: Colors.white),
                   enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: validatePassword,
                onSaved: (value){
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
                 child: Text('Change Password' , style: KLoginRegistrationButtonStyle),
                  onPressed:(){
                    bool isShowSpinner = _validateInputs();
                    setState(() {
                      showSpinner = isShowSpinner;
                    });
                    validateUserPassword(oldPassword);
                    setState(() {
                      showSpinner = isShowSpinner;
                    });
                    print('password changed');
                    //update the password with new value and navigate the user to login screen.
                  }
                  )
            ],
          ),
        ),
      ),
    );
  }
}

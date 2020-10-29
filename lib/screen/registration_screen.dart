import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:comperio/constants.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:comperio/screen_app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';

import '../helper_functions.dart';

class RegistrationScreen extends StatefulWidget {
  final String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String username;
  String password;
  File _image;
  String url =
      'https://firebasestorage.googleapis.com/v0/b/comperio-1071d.appspot.com/o/default-profile.webp?alt=media&token=52b10457-a10a-417e-b5af-3d84e5833fae';

  Future getImages() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    var image = File(pickedFile.path);

    setState(() {
      _image = image;
      // print('Image path $_image');
    });
  }

  void _addToDatabase(String userName, String dpUrl) {
    print('dpurl is: $dpUrl');
    List<String> splitList = username.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }
    // print(indexList);
    FirebaseFirestore.instance.collection('users').doc(username).set({
      'username': userName,
      'searchKeywords': indexList,
      'profileURL': dpUrl,
      'email': email,
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var dowUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = dowUrl.toString();
    print(url);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validateUserName(String value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid username';
    else
      return null;
  }

  String validatePassword(String value) {
    Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Password, include letters and numbers';
    else
      return null;
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/app-background.jpg'),
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
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 25, bottom: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'New',
                                      style: KCardTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'Account',
                                      style: KCardTextStyle,
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    overflow: Overflow.visible,
                                    children: [
                                      Container(
                                        width: 80.0,
                                        height: 80.0,
                                        child: CircleAvatar(
                                          radius: 40.0,
                                          backgroundColor: Colors.black12,
                                          child: ClipOval(
                                            child: SizedBox(
                                              width: 80.0,
                                              height: 80.0,
                                              child: (_image != null)
                                                  ? Image.file(
                                                      _image,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.asset(
                                                      'images/default-profile.jpg',
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -1,
                                        right: -30,
                                        bottom: -40,
                                        left: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera,
                                            color: Colors.blueAccent,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            getImages();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      validator: validateEmail,
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                        email = value;
                                      },
                                      // onChanged: (String value) {
                                      //   // This optional block of code can be used to run
                                      //   // code when the user saves the form.
                                      //   email = value;
                                      // },
                                    ),
                                    SizedBox(
                                      height: 20.0,
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
                                      validator: validateUserName,
                                      onSaved: (String value) {
                                        username = value;
                                      },
                                      // onChanged: (String value) {
                                      //   // This optional block of code can be used to run
                                      //   // code when the user saves the form.
                                      //   username = value;
                                      // },
                                    ),
                                    SizedBox(
                                      height: 20.0,
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
                                      validator: validatePassword,
                                      onSaved: (String value) {
                                        password = value;
                                      },
                                      // onChanged: (String value) {
                                      //   // This optional block of code can be used to run
                                      //   // code when the user saves the form.
                                      //   password = value;
                                      // },
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
                                          bool isShowSpinner =
                                              _validateInputs();
                                          setState(() {
                                            showSpinner = isShowSpinner;
                                          });
                                          try {
                                            // final newUser = await _auth
                                            //     .createUserWithEmailAndPassword(
                                            //         email: email,
                                            //         password: password);

                                            await _auth
                                                .createUserWithEmailAndPassword(
                                                    email: email,
                                                    password: password)
                                                .then((newUser) {
                                              if (newUser != null) {
                                                HelperFunctions
                                                    .saveUserLoggedInSharedPreference(
                                                        true);
                                                HelperFunctions
                                                    .saveUserNameSharedPreference(
                                                        username);
                                                HelperFunctions
                                                    .saveUserEmailSharedPreference(
                                                        email);
                                                HelperFunctions
                                                    .saveUserPhotoUrlSharedPreference(
                                                        url);

                                                Navigator.pushNamed(context,
                                                    ContactedPersonScreen().id);
                                              }
                                            });

                                            if (_image != null) {
                                              await uploadPic(context);
                                            }

                                            _addToDatabase(username, url);

                                            setState(() {
                                              showSpinner = false;
                                            });
                                          } catch (e) {
                                            print(e);
                                          //   AlertDialog(
                                          //     title:Text('Alert'),
                                          //     content: Text(e),
                                          //     actions: <Widget>[
                                          //       FlatButton(
                                          //         child: Text('Ok'),
                                          //         onPressed: (){
                                          //           Navigator.of(context).pop();
                                          //         },
                                          //       ),
                                          //     ],
                                          //   );

                                          }
                                        },
                                        child: Text(
                                          'Sign up',
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
                            ),
                          ],
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

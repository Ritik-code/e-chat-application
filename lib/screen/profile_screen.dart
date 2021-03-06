// To-Do:
// -when viewing own profile:
// fetch current user name, email and profile photo, provide edit options,  don't show send message button
// -when viewing other person profile:
// fetch searched result's name, email and profile photo, show send message button

// -when viewing faculty profile:
// show rating
// -when viewing student profile:
// don't show rating

// - adding rating mechanism

// - show @professor when faculty and @student when student's profile

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:comperio/constants.dart';
import 'package:commons/commons.dart';

class ProfileScreen extends StatefulWidget {
  final String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName;
  String emailId;
  String picURL =
      'https://firebasestorage.googleapis.com/v0/b/comperio-1071d.appspot.com/o/default-profile.webp?alt=media&token=52b10457-a10a-417e-b5af-3d84e5833fae';
  File _image;
  bool showSpinner = false;
  String url = "";
  String role;

  getUserInfo() async {
    String username = await HelperFunctions.getUserNameSharedPreference();
    String email = await HelperFunctions.getUserEmailSharedPreference();
    String myrole = await HelperFunctions.getUserRoleSharedPreference();
    var dp = await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .get();
    setState(() {
      userName = username;
      emailId = email;
      role = myrole;
      picURL = dp.data()['profileURL'];
    });
    print(picURL);
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getImages() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    var image = File(pickedFile.path);

    setState(() {
      _image = image;
      // print('Image path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var dowUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    url = dowUrl.toString();

    //print(url);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/app-background-3.jpg'),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7.0,
                          color: Colors.black,
                        )
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      overflow: Overflow.visible,
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.black12,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 100.0,
                                    height: 100.0,
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
                              )
                            : CircleAvatar(
                                radius: 50.0,
                                backgroundImage: (picURL != null)
                                    ? NetworkImage(picURL)
                                    : AssetImage('images/default-profile.jpg'),
                              ),
                        Positioned(
                          top: -1,
                          right: -45,
                          bottom: -50,
                          left: 40,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera,
                              color: Colors.white,
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
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    userName != null ? userName : 'abc',
                    style: KProfileUsernameTextStyle,
                  ),
                  Text(
                    role != null ? "@" + role : "@role",
                    style: KProfileUserRoleTextStyle,
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(Icons.email, color: Colors.teal),
                      title: Align(
                        child: Text(
                          emailId != null ? emailId : 'abc@gmail.com',
                          style: KProfileEmailTextStyle,
                        ),
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                  ),

                  // adding rating bar showing the overall average rating
//              Container(
//                RatingBar(
//    initialRating: 3,
//    minRating: 1,
//    direction: Axis.horizontal,
//    allowHalfRating: true,
//    itemCount: 5,
//    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//    itemBuilder: (context, _) => Icon(
//      Icons.star,
//      color: Colors.amber,
//    ),
//    onRatingUpdate: (rating) {
//      print(rating);
//    },
// );),
                  Container(
                      height: 50.0,
                      width: 170.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.blueAccent,
                        color: Colors.blueAccent,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            if (_image != null) {
                              await uploadPic(context);
                            }
                            // print(url);
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userName)
                                .update({
                              'profileURL': url,
                            });
                            setState(() {
                              showSpinner = false;
                            });
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text("Successful!"),
                            //         content: Text("Profile Pic Updated."),
                            //         actions: [
                            //           FlatButton(
                            //             child: Text("OK"),
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //           )
                            //         ],
                            //       );
                            //     });
                            successDialog(
                              context,
                              "Profile Pic Updated",
                              neutralText: "Okay",
                            );
                          },
                          child: Center(
                            child: Text(
                              'Save',
                              style: KProfileButtonTextStyle,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

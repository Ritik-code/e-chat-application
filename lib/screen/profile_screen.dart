import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  final String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName;
  String emailId;
  String picURL;
        body: SafeArea(
            inAsyncCall: showSpinner,
              decoration: BoxDecoration(
                      fit: BoxFit.cover)),
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
                        _image!=null?
                        CircleAvatar(
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
                        ):
                        CircleAvatar(
                            radius: 50.0,
                            backgroundImage:NetworkImage(
                                (picURL != null)
                                ? picURL
                                : 'https://firebasestorage.googleapis.com/v0/b/comperio-1071d.appspot.com/o/default-profile.webp?alt=media&token=52b10457-a10a-417e-b5af-3d84e5833fae'),
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
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
=======
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
                  child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage((picURL != null)
                          ? picURL
                          : 'https://firebasestorage.googleapis.com/v0/b/comperio-1071d.appspot.com/o/default-profile.webp?alt=media&token=52b10457-a10a-417e-b5af-3d84e5833fae')),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  userName != null ? userName : 'abc',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
>>>>>>> master
                  ),
                  Text(
                    '@Professor',
                    style: TextStyle(
                      color: Colors.teal[100],
                      fontSize: 20.0,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(Icons.email, color: Colors.teal),
                      title: Align(
                        child: Text(
                          emailId != null ? emailId : 'abc@gmail.com',
                          style: TextStyle(
                            color: Colors.teal[900],
                            fontSize: 20.0,
                          ),
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
                            FirebaseFirestore.instance.collection('users').doc(userName).set(
                                {'profileURL': url,});
                            setState(() {
                              showSpinner = false;
                            });
                          },
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
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

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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
class ProfileScreen extends StatefulWidget {
  final String id = 'ProfileScreen';
  File _image;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;


  
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
    print(url);
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
        
          child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/564x/84/c0/19/84c019fbb489f4025ba4f2b8754582c3.jpg"),
              fit: BoxFit.cover)
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
           
            Container(decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 7.0, color: Colors.black, )
              ],
            ),
                 child:     CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage('https://www.vhv.rs/file/max/34/340444_avatar-png.jpg'),
             ),
                     ),
           
            Text(
               'Rahul Verma',
               style: TextStyle(
               fontSize: 40.0,
               color: Colors.white,
               fontWeight: FontWeight.bold,
               ),
               ),
            Text(
              '@Professor',
              style:TextStyle(
                color: Colors.teal[100],
                fontSize: 20.0,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
                ),
            ),
               
             SizedBox(
             height:10.0,
             
             
             ),
           
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical:20.0, horizontal: 30.0),
              
              child: ListTile( 
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                 leading: Icon(Icons.email,
                      color: Colors.teal),
              title: Align(
                      child: Text('abc@gmail.com',
                              style:TextStyle(
                                color: Colors.teal[900],
                                           fontSize: 20.0,),),
                    alignment: Alignment(-2.5, 0),
                
                ),),
               
                
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
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'Send Message',
                            style: TextStyle(color: Colors.white, fontSize: 18.0,fontWeight:FontWeight.bold,),
                          ),
                        ),
                      ),
                    ))
          ],
        ),
      
      ),
     ),),
    );
  }
}
}
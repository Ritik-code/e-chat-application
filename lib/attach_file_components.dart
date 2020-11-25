import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'helper_functions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AttachFileBottomSheet extends StatefulWidget {
  Widget getImageBubble(String FileUrl, BuildContext context, bool isMe) {
    return GestureDetector(
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          elevation: 10.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5.0,
                  color: isMe ? Color(0xff81d4fa) : Colors.white,
                ),
              ),
              child: Image.network(
                FileUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        onTap: () {
          print("tapped");
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return FullScreenImage(FileUrl);
          }));
        });
  }

  // Widget getVideoBubble(String FileUrl, BuildContext context, bool isMe){
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(8.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         Stack(
  //           alignment: AlignmentDirectional.center,
  //           children: <Widget>[
  //             Container(
  //               padding: EdgeInsets.all(3.0),
  //               width: 130,
  //               color: Colors.black87,
  //               height: 80,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: <Widget>[
  //                   IconButton(
  //                     icon: Icon(
  //                       Icons.play_arrow,
  //                       color: Colors.lightBlueAccent,
  //                     ),
  //                     onPressed: (){
  //
  //                     },
  //                   ),
  //                   Text(
  //                     'Video',
  //                     style: TextStyle(
  //                         fontSize: 20,
  //                         color: isMe
  //                             ? Colors.lightBlueAccent
  //                             : Colors.lightBlueAccent),
  //                   ),
  //
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

  @override
  _AttachFileBottomSheetState createState() => _AttachFileBottomSheetState();
}

class _AttachFileBottomSheetState extends State<AttachFileBottomSheet> {
  File _file;
  String url;
  String user;
  String email;
  String username;
  String chatRoomId;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserName();
  }

  getCurrentUser() async {
    final User user = await _auth.currentUser;
    // final uid = user.uid;
    // Similarly we can get email as well
    email = user.email;
    print('user is $email');
  }

  getUserName() async {
    String chatId = await HelperFunctions.getChatRoomIdSharedPreference();
    String myUsername = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      chatRoomId = chatId;
      username = myUsername;
    });
    print(url);
    print(chatRoomId);
  }

  Future getFiles(BuildContext context) async {
    getCurrentUser();
    File pickedFile;
    var file;
    pickedFile =
        await FilePicker.getFile(type: FileType.image).whenComplete(() {
      setState(() {
        _showMyDialog(context);
      });
    }).catchError((e) {
      print(e);
    });
    file = File(pickedFile.path);
    setState(() {
      _file = file;
      // print('Image path $_image');
    });
  }

  Future uploadFile(BuildContext context) async {
    Navigator.pop(context);
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: "Sending file...",
      duration: Duration(seconds: 3),
    )
      ..show(context);
    print('Uploading file.......');
    String fileName = basename(_file.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_file);
    var dowUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = dowUrl.toString();
    print(url);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    _addToDatabase(url, email, context);
  }

  void _addToDatabase(String fileUrl, String emailID, BuildContext context) {
    // print(indexList);
    print('adding to database......');
    FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection('Messages')
        .doc()
        .set({
      'sender': emailID,
      'fileUrl': fileUrl,
      'Date':
      DateFormat('dd-MMM-yy hh:mm:ss').format(DateTime.now()).toString(),
      'message': " ",
      'orderDateFormat':
      DateFormat('dd-MMM-yy hh:mm:ss').format(DateTime.now()).toString(),
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(chatRoomId)
        .collection("chatRoom")
        .doc(username)
        .collection('Messages')
        .doc()
        .set({
      'sender': emailID,
      'fileUrl': fileUrl,
      'Date':
      DateFormat('dd-MMM-yy hh:mm:ss').format(DateTime.now()).toString(),
      'message': " ",
      'orderDateFormat':
      DateFormat('dd-MMM-yy hh:mm:ss').format(DateTime.now()).toString(),
    });
    print('added to database');
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Send this file?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Send'),
              onPressed: () {
                // Navigator.of(context).pop();

                setState(() {
                  uploadFile(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.image),
      onPressed: () {
        getFiles(context);
      },
      color: Colors.deepOrange,
      iconSize: 30.0,
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String FileUrl;
  FullScreenImage(this.FileUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black87,
        child: Center(child: Image.network(FileUrl, fit: BoxFit.contain)),
      ),
    );
  }
}

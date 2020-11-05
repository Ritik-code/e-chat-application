import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:comperio/screen/contacted_person_screen.dart';
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

  Future getFiles(FileType fileType, BuildContext context) async {
    getCurrentUser();
    File pickedFile;
    var file;
    pickedFile = await FilePicker.getFile(type: fileType).whenComplete(() {
      setState(() {
        _showMyDialog(context);
      });
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
    )..show(context);
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
    FirebaseFirestore.instance.collection('users')
        .document(username)
        .collection("chatRoom")
        .document(chatRoomId)
        .collection('Messages').doc().set({
      'sender': emailID,
      'fileUrl': fileUrl,
      'Date':
      DateFormat('dd-MMM-yy hh:mm:ss').format(DateTime.now()).toString(),
      'message': " ",
      'orderDateFormat':
      DateFormat('dd-MMM-yy hh:mm:ss').format(DateTime.now()).toString(),
    });
    FirebaseFirestore.instance.collection('users')
        .document(chatRoomId)
        .collection("chatRoom")
        .document(username)
        .collection('Messages').doc().set({
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
                Navigator.of(context).pop();

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


  getFileMessageBubble(){}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 8.0),
      height: 100.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AttachFileIcon(
              icon: Icons.image,
              color: Colors.deepOrange,
              text: 'Image',
              onPressed: () {
                getFiles(FileType.image, context);
              }),
          AttachFileIcon(
              icon: Icons.videocam,
              color: Colors.blue,
              text: 'Video',
              onPressed: () {
                getFiles(FileType.video, context);
              }),
          AttachFileIcon(
              icon: Icons.insert_drive_file,
              color: Colors.yellow,
              text: 'File',
              onPressed: () {
                getFiles(FileType.any, context);
              }),
        ],
      ),
    );
  }
}

class AttachFileIcon extends StatelessWidget {
  AttachFileIcon(
      {@required this.icon,
        @required this.color,
        @required this.text,
        @required this.onPressed});

  final IconData icon;
  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: color,
          iconSize: 30.0,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
        ),
      ],
    );
  }
}
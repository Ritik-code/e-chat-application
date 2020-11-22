import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/app_icons.dart';
import 'package:comperio/attach_file_components.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/helper_functions.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

import 'feedback_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
String chatRoomId = "test";
String username = "admin";
String url = "";
String myUrl = "";
String myrole = "";
String receiverRole = "";

class ChatScreen extends StatefulWidget {
  final String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText = "";

  getUserName() async {
    String chatId = await HelperFunctions.getChatRoomIdSharedPreference();
    String myUsername = await HelperFunctions.getUserNameSharedPreference();
    var receiverInfo =
        await FirebaseFirestore.instance.collection('users').doc(chatId).get();
    String myUrl = await HelperFunctions.getUserPhotoUrlSharedPreference();
    String MyRole = await HelperFunctions.getUserRoleSharedPreference();

    // String pUrl = ;
    setState(() {
      chatRoomId = chatId;
      username = myUsername;
      url = receiverInfo.data()['profileURL'];
      receiverRole = receiverInfo.data()['role'];
      myUrl = myUrl;
      myrole = MyRole;
    });
    print(url);
    print(chatRoomId);
    print(myrole);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserName();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('users')
        .doc(username)
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection('Messages')
        .snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1d2d50),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 40.0, left: 10.0, right: 20.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: AppIcons(
                          iconName: Icons.arrow_back,
                          iconSize: 30.0,
                          colour: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ContactedPersonScreen().id);
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: Image.network(
                              url,
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        chatRoomId,
                        style: KUserTextStyle,
                      ),
                      // SizedBox(
                      //   width: 100.0,
                      // ),
                    ],
                  ),
                  (myrole == "Student")
                      ? (receiverRole == "Professor")
                          ? IconButton(
                              alignment: Alignment.centerRight,
                              icon: AppIcons(
                                iconName: Icons.feedback,
                                iconSize: 30.0,
                                colour: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, FeedbackScreen().id);
                              },
                            )
                          : Container()
                      : Container(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('images/chat_bg8.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    MessagesStream(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 5.0, left: 3.0),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AttachFileBottomSheet(),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: messageTextController,
                          onChanged: (value) {
                            //do something when pressed
                            messageText = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            hintText: 'Type your message here...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        color: Color(0xFF1d2d50),
                        onPressed: () {
                          //Implement send functionality.
                          messageTextController.clear();
                          if (messageText.isNotEmpty) {
                            _firestore
                                .collection('users')
                                .document(username)
                                .collection("chatRoom")
                                .document(chatRoomId)
                                .collection('Messages')
                                .add({
                              'message': messageText,
                              'sender': loggedInUser.email,
                              'Date': DateFormat('dd-MMM-yy hh:mm')
                                  .format(DateTime.now())
                                  .toString(),
                              'fileUrl': " ",
                              'type': " ",
                              'orderDateFormat':
                                  DateFormat('dd-MMM-yy hh:mm:ss')
                                      .format(DateTime.now())
                                      .toString(),
                            });
                            Firestore.instance
                                .collection('users')
                                .document(chatRoomId)
                                .collection("chatRoom")
                                .document(username)
                                .set({
                              "users": [chatRoomId, username],
                              "chatRoomId": username,
                              "profileUrl": myUrl,
                            });

                            _firestore
                                .collection('users')
                                .document(chatRoomId)
                                .collection("chatRoom")
                                .document(username)
                                .collection('Messages')
                                .add({
                              'message': messageText,
                              'sender': loggedInUser.email,
                              'Date': DateFormat('dd-MMM-yy hh:mm')
                                  .format(DateTime.now())
                                  .toString(),
                              'fileUrl': " ",
                              'type': " ",
                              'orderDateFormat':
                                  DateFormat('dd-MMM-yy hh:mm:ss')
                                      .format(DateTime.now())
                                      .toString(),
                            });
                          }

                          setState(() {
                            messageText = "";
                          });
                        },
                        shape: CircleBorder(),
                        child: AppIcons(
                          iconName: Icons.send,
                          iconSize: 20.0,
                          colour: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .document(username)
          .collection("chatRoom")
          .document(chatRoomId)
          .collection('Messages')
          .orderBy('orderDateFormat')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['message'];
          final messageSender = message.data()['sender'];
          final messageDateTime = message.data()['Date'];
          final messageFile = message.data()['fileUrl'];
          final messageType = message.data()['type'];
          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            dateTime: messageDateTime,
            isMe: currentUser == messageSender,
            messageFileUrl: messageFile,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String dateTime;
  final String messageFileUrl;
  final String messageType;

  MessageBubble(
      {this.sender,
      this.text,
      this.isMe,
      this.dateTime,
      this.messageFileUrl,
      this.messageType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   sender,
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          (messageFileUrl == " ")
              ? Container(
                  constraints: BoxConstraints(
                    maxWidth: 2 * (MediaQuery.of(context).size.width) / 3,
                  ),
                  child: Material(
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                    elevation: 10.0,
                    color: isMe ? Color(0xff81d4fa) : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              : AttachFileBottomSheet()
                  .getImageBubble(messageFileUrl, context, isMe),
          Text(
            dateTime,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

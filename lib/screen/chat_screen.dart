import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/app_icons.dart';
import 'package:comperio/attach_file_components.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/helper_functions.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




final _firestore = FirebaseFirestore.instance;
User loggedInUser;
String chatRoomId ;

class ChatScreen extends StatefulWidget {
  final String id = 'ChatScreen';
  

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
    
     

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  String username = "";

   getUserName() async{
     String chatId = await HelperFunctions.getChatRoomIdSharedPreference();
     setState(() {
       chatRoomId = chatId;
     });
     print(chatRoomId);
       var snapshot = await Firestore.instance.collection('users').document(Constants.myName)
           .collection("chatRoom")
           .document(chatRoomId).get();
     setState(() {
       username =  snapshot.data()['users'][0];

     });
     print(username);
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
    await for (var snapshot in _firestore.collection('users').document(Constants.myName)
        .collection("chatRoom").document(chatRoomId).collection('Messages').snapshots()) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: AppIcons(
                      iconName: Icons.arrow_back,
                      iconSize: 30.0,
                      colour: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ContactedPersonScreen().id);
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    chatRoomId,
                    style: KUserTextStyle,
                  ),
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
                      IconButton(
                        icon: Icon(FontAwesomeIcons.paperclip),
                        color: Colors.blueGrey,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return AttachFileBottomSheet();
                            },
                          );
                        },
                      ),
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
                          messageTextController.clear();
                          //Implement send functionality.
                          _firestore.collection('users').document(Constants.myName)
                              .collection("chatRoom").document(chatRoomId).collection('Messages').add({
                            'message': messageText,
                            'sender': loggedInUser.email,
                            'Date': DateFormat('dd-MMM-yy hh:mm')
                                .format(DateTime.now())
                                .toString(),
                            'fileUrl': " ",
                            'orderDateFormat': DateFormat('dd-MMM-yy hh:mm:ss')
                                .format(DateTime.now())
                                .toString(),
                          });
                          _firestore.collection('users').document(chatRoomId)
                              .collection("chatRoom").document(Constants.myName).collection('Messages').add({
                            'message': messageText,
                            'sender': loggedInUser.email,
                            'Date': DateFormat('dd-MMM-yy hh:mm')
                                .format(DateTime.now())
                                .toString(),
                            'fileUrl': " ",
                            'orderDateFormat': DateFormat('dd-MMM-yy hh:mm:ss')
                                .format(DateTime.now())
                                .toString(),
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
      stream: _firestore.collection('users').document(Constants.myName)
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

  MessageBubble(
      {this.sender, this.text, this.isMe, this.dateTime, this.messageFileUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          (text != " ")
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
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Container(
                            width: 130,
                            color: Colors.black87,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  'File',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: isMe
                                          ? Colors.lightBlueAccent
                                          : Colors.lightBlueAccent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 130.0,
                        color: Colors.lightBlueAccent,
                        child: IconButton(
                          icon: Icon(
                            Icons.file_download,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
          Text(
            dateTime,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

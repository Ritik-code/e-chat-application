import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class SearchStreamBuilder extends StatelessWidget {
  SearchStreamBuilder({this.username});

  final String username;

  createChatRoom(BuildContext context ,String username){

    List<String> users = [Constants.myName, username];

    String chatRoomId = getChatRoomId(Constants.myName, username);


    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
    Navigator.pushNamed(context, ChatScreen().id);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (username != "" && username != null)
          ? FirebaseFirestore.instance
              .collection('users')
              .where("searchKeywords", arrayContains: username)
              .snapshots() //TODO: Recent searches to be added here
          : FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.docs[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          (data.data()['profileURL'] != null)
                              ? CircleAvatar(
                                  radius: 25.0,
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Image.network(
                                        data.data()['profileURL'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 25.0,
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Image.asset(
                                        'images/default-profile.jpg',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 25.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              String user = data.data()['username'];
                              createChatRoom(context, user);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringUtils.capitalize(
                                      data.data()['username']),
                                  style: KSearchDisplayNameTextStyle,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Faculty',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

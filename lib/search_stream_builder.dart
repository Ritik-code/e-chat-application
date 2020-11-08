import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/helper_functions.dart';
import 'package:comperio/screen/chat_screen.dart';
import 'package:comperio/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class SearchStreamBuilder extends StatefulWidget {
  SearchStreamBuilder({this.username});

  final String username;

  @override
  _SearchStreamBuilderState createState() => _SearchStreamBuilderState();
}

class _SearchStreamBuilderState extends State<SearchStreamBuilder> {
  bool showSpinner = false;
  String isMe;
  // String url;

  getUserName() async {
    String me = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      isMe = me;
    });
    print(isMe);
  }
  // getUrl(String username) async{
  //   var Url = await Firestore.instance.collection('users').document(username).get();
  //   String pUrl = Url.data()['profileURL'];
  //   setState(() {
  //     url = pUrl;
  //   });
  // }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  createChatRoom(
      BuildContext context, String username, String url, String role) {
    List<String> users = [isMe, username];
    String chatRoomId = username;
    HelperFunctions.saveChatRoomIdSharedPreference(chatRoomId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
      "profileUrl": url,
      "role": role,
    };
    print("chat room id $chatRoomId");
    print("users are $users");
    print("profile url is $url");
    print("role is $role");

    FirebaseFirestore.instance
        .collection('users')
        .doc(isMe)
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
    Navigator.pushNamed(context, ChatScreen().id);
  }

  // getChatRoomId(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("searchKeywords", arrayContains: widget.username)
          .snapshots(), //TODO: Recent searches to be added here

      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.docs[index];
                  if(data.data()['username'] == 'test' ||
                      data.data()['username'] == 'admin') {
                    return Container();
                  }
                  return Card(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child:  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            data.data()['role'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  isMe != data.data()['username']
                                      ? RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          color: Colors.lightBlueAccent,
                                          elevation: 5.0,
                                          onPressed: () {
                                            setState(() {
                                              showSpinner = true;
                                            });
                                            String user =
                                                data.data()['username'];
                                            String url =
                                                data.data()['profileURL'];
                                            String role = data.data()['role'];
                                            createChatRoom(
                                                context, user, url, role);
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          },
                                          child: Text(
                                            'Message',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        )
                                      : RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pushNamed(
                                                  context, ProfileScreen().id);
                                            });
                                          },
                                          color: Colors.cyan,
                                          elevation: 5.0,
                                          child: Text(
                                            'You',
                                            style: TextStyle(
                                                color: Colors.black54),
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

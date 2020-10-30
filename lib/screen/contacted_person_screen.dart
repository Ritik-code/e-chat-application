
import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/app_icons.dart';
import 'package:comperio/choice.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/contact_popup_menu.dart';
import 'package:comperio/helper_functions.dart';
import 'package:comperio/screen/chat_screen.dart';
import 'package:comperio/screen/searchScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactedPersonScreen extends StatefulWidget {
  final String id = 'ContactedPersonScreen';

  @override
  _ContactedPersonScreenState createState() => _ContactedPersonScreenState();
}
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Profile', icon: FontAwesomeIcons.user),
    const Choice(title: 'Change Password', icon: FontAwesomeIcons.key),
    const Choice(title: 'Log out', icon: FontAwesomeIcons.signOutAlt),
  ];
  String chatRoomId ;

class _ContactedPersonScreenState extends State<ContactedPersonScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String username;
  // Stream myStream;
  // String url ;

  getUserInfo() async {
    String name = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      username = name;
    });
  }

  createChatRoom(BuildContext context, String receiver, String url) {
    List<String> users = [username, receiver];
    String chatRoomId = receiver;
    HelperFunctions.saveChatRoomIdSharedPreference(chatRoomId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
      "profileUrl": url,

    };

    Firestore.instance.collection('users').document(username)
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
    Navigator.pushNamed(context, ChatScreen().id);

  }

  @override
    void initState() {
      super.initState();
      getUserInfo();

    }
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit App'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => SystemNavigator.pop(),
            /*Navigator.of(context).pop(true)*/
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff311b92),
            image: DecorationImage(
              image: AssetImage('images/app-background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: AppIcons(
                iconName: Icons.group_add,
                iconSize: 30.0,
                colour: Colors.white,
              ),
              backgroundColor: Color(0xff0d47a1),
            ),
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CircleAvatar(
                      //   radius: 17.0,
                      //   backgroundColor: Colors.white,
                      // ),
                      // SizedBox(
                      //   width: 7.0,
                      // ),
                      Text(
                        'Comperio',
                        style: KAppNameTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: AppIcons(
                                iconName: Icons.search,
                                colour: Colors.white,
                                iconSize: 35.0),
                            onPressed: () {
                              Navigator.pushNamed(context, SearchScreen().id);
                            },
                          ),
                          ContactPopupMenu(choices: choices),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users')
                          .document(username)
                          .collection('chatRoom')
                          .snapshots(),
                      builder: (context, snapshot) {

                        return (snapshot.connectionState ==
                            ConnectionState.waiting)
                            ? Center(child: CircularProgressIndicator()) :
                        ListView.separated(
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey,),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data = snapshot.data.docs[index];
                              // print(data.data()['profileUrl']);
                              // print(data.data()['users'][1]);
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      (data.data()['profileUrl'] != null)
                                          ? CircleAvatar(
                                        radius: 25.0,
                                        child: ClipOval(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.network(
                                              data.data()['profileUrl'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ):
                                       CircleAvatar(
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
                                      Text(
                                        StringUtils.capitalize(
                                            data.data()['users'][1]),
                                        style: KSearchDisplayNameTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: (){
                                  String user = data.data()['users'][1];
                                  String url = data.data()['profileUrl'];
                                  createChatRoom(context, user, url);
                                },
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:comperio/screen/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactedPersonScreen extends StatefulWidget {
  final String id = 'ContactedPersonScreen';

  @override
  _ContactedPersonScreenState createState() => _ContactedPersonScreenState();
}

class _ContactedPersonScreenState extends State<ContactedPersonScreen> {
  final user = FirebaseAuth.instance.currentUser;

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Profile', icon: FontAwesomeIcons.user),
    const Choice(title: 'Change Password', icon: FontAwesomeIcons.key),
    const Choice(title: 'Log out', icon: FontAwesomeIcons.signOutAlt),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Icon(Icons.group_add, size: 30.0,),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.white,size: 35.0,),
                        onPressed: (){
                          // return TextField(
                          //   decoration: InputDecoration(
                          //     hintText: 'search...',
                          //   ),
                          //
                          // );
                        },
                      ),


                      PopupMenuButton<Choice>(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (BuildContext context) {
                          return choices.map((Choice choice) {
                            return PopupMenuItem<Choice>(
                              value: choice,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    choice.icon,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width: 10.0,
                                  ),
                                  Text(
                                    choice.title,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        icon: Icon(FontAwesomeIcons.ellipsisV,color:Colors.white,),
                      ),

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
                child: ListView(
                  //all the message will be added here.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {

  final String title;
  final IconData icon;

  const Choice({this.title, this.icon});
}


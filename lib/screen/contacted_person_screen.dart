import 'package:comperio/app_icons.dart';
import 'package:comperio/choice.dart';
import 'package:comperio/constants.dart';
import 'package:comperio/contact_popup_menu.dart';
import 'package:comperio/helper_functions.dart';
import 'package:comperio/screen/searchScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class _ContactedPersonScreenState extends State<ContactedPersonScreen> {
  final user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async => Constants.myName = await HelperFunctions.getUserNameSharedPreference();

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


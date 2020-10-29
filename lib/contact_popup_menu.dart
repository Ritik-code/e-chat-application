import 'package:comperio/app_icons.dart';
import 'package:comperio/choice.dart';
import 'package:comperio/helper_functions.dart';
import 'package:comperio/screen/change_password_screen.dart';
import 'package:comperio/screen/contacted_person_screen.dart';
import 'package:comperio/screen/profile_screen.dart';
import 'package:comperio/screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPopupMenu extends StatefulWidget {
  const ContactPopupMenu({
    Key key,
    @required this.choices,
  }) : super(key: key);

  final List<Choice> choices;

  @override
  _ContactPopupMenuState createState() => _ContactPopupMenuState();
}

class _ContactPopupMenuState extends State<ContactPopupMenu> {
  String _selectedChoice = choices[0].title;

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      Navigator.pushNamed(context, WelcomeScreen().id);
    } catch (e) {
      print(e);
    }
  }
  void _showDialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to Log out.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => _signOut(),
            /*Navigator.of(context).pop(true)*/
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice.title;
      if (_selectedChoice == 'Log out') {
        _showDialog();
        print('Log Out');
      } else if (_selectedChoice == 'Change Password') {
        Navigator.pushNamed(context, ChangePasswordScreen().id);
        print('Change Password');
      } else if (_selectedChoice == 'Profile') {
        Navigator.pushNamed(context, ProfileScreen().id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context) {
        return widget.choices.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Row(
              children: <Widget>[
                AppIcons(
                  iconName: choice.icon,
                  iconSize: 20.0,
                  colour: Colors.black,
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
      onSelected: _select,
      icon: Icon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.white,
      ),
    );
  }
}

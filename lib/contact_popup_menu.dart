import 'package:comperio/app_icons.dart';
import 'package:comperio/choice.dart';
import 'package:comperio/screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:comperio/screen/contacted_person_screen.dart';



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

  Future<void> _signOut() async{
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, WelcomeScreen().id);
    }
    catch(e){
      print(e);
    }

  }

  void _select(Choice choice){
    setState(() {
      _selectedChoice = choice.title;
      if(_selectedChoice == 'Log out'){
        _signOut();
        print('Log Out');
      }
      else if(_selectedChoice == 'Change Password'){
        print('Change Password');
      }
      else if(_selectedChoice == 'Profile'){
        print('Profile');
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





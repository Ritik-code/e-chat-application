import 'package:comperio/app_icons.dart';
import 'package:comperio/choice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPopupMenu extends StatelessWidget {
  const ContactPopupMenu({
    Key key,
    @required this.choices,
  }) : super(key: key);

  final List<Choice> choices;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context) {
        return choices.map((Choice choice) {
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
      icon: Icon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.white,
      ),
    );
  }
}

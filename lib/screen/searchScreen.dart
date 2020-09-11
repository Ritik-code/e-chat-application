import 'package:comperio/app_icons.dart';
import 'package:comperio/search_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  final String id = 'SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchText = TextEditingController();
  String name = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: AppIcons(
                      iconName: Icons.arrow_back,
                      iconSize: 30.0,
                      colour: Colors.indigo,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchText,
                      cursorColor: Colors.indigo,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(FontAwesomeIcons.search, color: Colors.indigo),
                        suffixIcon: name.length > 0
                            ? IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.times,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchText.clear();
                                    name = "";
                                  });
                                },
                              )
                            : null,
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Search by username
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SearchStreamBuilder(
                  name: name,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

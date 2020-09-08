import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SearchScreen extends StatefulWidget {
  final String id = 'SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchText = TextEditingController();
  String newText = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back, color: Colors.indigo,size: 30.0,),
                    onPressed: (){
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
                        prefixIcon : Icon(FontAwesomeIcons.search, color: Colors.indigo),
                        suffixIcon: newText.length>0 ? IconButton(icon: Icon(FontAwesomeIcons.times, color: Colors.blueGrey,),
                          onPressed: (){
                          setState(() {
                            searchText.clear();
                            newText = "";
                          });
                          },
                        ): null ,
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value){
                        // Search by username
                        setState(() {
                          newText = value;
                        });
                      },
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

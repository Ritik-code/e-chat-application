import 'package:cloud_firestore/cloud_firestore.dart';
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.indigo,
                      size: 30.0,
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: (name != "" && name != null)
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where("searchKeywords", arrayContains: name)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("users")
                          .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data = snapshot.data.docs[index];
                              return Card(
                                child: Row(
                                  children: <Widget>[
                                    // Image.network(
                                    //   data['imageUrl'],
                                    //   width: 150,
                                    //   height: 100,
                                    //   fit: BoxFit.fill,
                                    // ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print('taped');
                                      },
                                      child: Text(
                                        data.data()['username'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

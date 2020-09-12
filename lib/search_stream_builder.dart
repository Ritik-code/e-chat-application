import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/constants.dart';
import 'package:flutter/material.dart';

class SearchStreamBuilder extends StatelessWidget {
  SearchStreamBuilder({this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (name != "" && name != null)
          ? FirebaseFirestore.instance
              .collection('users')
              .where("searchKeywords", arrayContains: name)
              .snapshots() //TODO: Recent searches to be added here
          : FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.docs[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
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
                          GestureDetector(
                            onTap: () {
                              print('taped');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringUtils.capitalize(
                                      data.data()['username']),
                                  style: KSearchDisplayNameTextStyle,
                                ),
                                Text(
                                  'Faculty',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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

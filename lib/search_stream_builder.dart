import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comperio/constants.dart';
import 'package:flutter/material.dart';

class SearchStreamBuilder extends StatelessWidget {
  const SearchStreamBuilder({
    Key key,
    @required this.name,
  }) : super(key: key);

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
                      padding: const EdgeInsets.all(8.0),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data()['username'],
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

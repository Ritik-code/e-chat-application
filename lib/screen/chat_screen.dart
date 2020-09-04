import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        image: DecorationImage(
          image: AssetImage('images/app-background-2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  CircleAvatar(
                    radius: 17.0,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 7.0,
                  ),
                  Text(
                    'username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
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
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 5.0, left: 10.0),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            //do something when pressed
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            hintText: 'Type your message here...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          //Implement send functionality.
                        },
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
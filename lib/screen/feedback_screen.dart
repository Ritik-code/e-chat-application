import 'package:comperio/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedbackScreen extends StatefulWidget {
  final String id = 'FeedbackScreen';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String myFeedbackText = "COULD BE BETTER";
  double sliderValue = 0.0;
  IconData myFeedback = FontAwesomeIcons.sadTear;
  Color myFeedbackColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            icon: AppIcons(
              iconName: Icons.arrow_back,
              iconSize: 25.0,
              colour: Colors.white,
            ),
            onPressed: () {
              //
            }),
        title: Center(child: Text("Feedback")),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.solidStar),
              onPressed: () {
                //
              }),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/container_background2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                    child: Center(
                      child: Text(
                        "On a scale of 1 to 5, rate our app",
                        style: TextStyle(
                            color: Color(0xFFf2fcfe),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              child: Material(
                color: Color(0xFFf2fcfe),
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0xFF70e1f5),
                child: Container(
                    width: 350.0,
                    height: 450.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                              child: Text(
                                myFeedbackText,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25.0),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            child: AppIcons(
                              iconName: myFeedback,
                              iconSize: 120.0,
                              colour: myFeedbackColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            child: Slider(
                              min: 0.0,
                              max: 5.0,
                              divisions: 5,
                              value: sliderValue,
                              activeColor: Color(0xFF005C97),
                              inactiveColor: Color(0xFF70e1f5),
                              onChanged: (newValue) {
                                setState(() {
                                  sliderValue = newValue;
                                  if (sliderValue <= 0.4) {
                                    myFeedback = FontAwesomeIcons.neos;
                                    myFeedbackColor = Color(0xeeb6fbff);
                                    myFeedbackText = "REMARK";
                                  }
                                  if (sliderValue >= 0.5 &&
                                      sliderValue <= 1.0) {
                                    myFeedback = FontAwesomeIcons.sadTear;
                                    myFeedbackColor = Color(0xFFED213A);
                                    myFeedbackText = "COULD BE BETTER";
                                  }
                                  if (sliderValue >= 1.1 &&
                                      sliderValue <= 2.0) {
                                    myFeedback = FontAwesomeIcons.frown;
                                    myFeedbackColor = Color(0xFFF27121);
                                    myFeedbackText = "BELOW AVERAGE";
                                  }
                                  if (sliderValue >= 2.1 &&
                                      sliderValue <= 3.0) {
                                    myFeedback = FontAwesomeIcons.meh;
                                    myFeedbackColor = Colors.amber;
                                    myFeedbackText = "NORMAL";
                                  }
                                  if (sliderValue >= 3.1 &&
                                      sliderValue <= 4.0) {
                                    myFeedback = FontAwesomeIcons.smile;
                                    myFeedbackColor = Colors.green;
                                    myFeedbackText = "GOOD";
                                  }
                                  if (sliderValue >= 4.1 &&
                                      sliderValue <= 5.0) {
                                    myFeedback = FontAwesomeIcons.laugh;
                                    myFeedbackColor = Color(0xFF00B4DB);
                                    myFeedbackText = "EXCELLENT";
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Container(
                              child: Text(
                                "Your Rating: $sliderValue",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                              height: 45.0,
                              width: 150.0,
                              child: RaisedButton(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.blueAccent,
                                onPressed: () {},
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

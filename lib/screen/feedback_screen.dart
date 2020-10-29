import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import '../screen_app_logo.dart';

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
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/app-background.jpg"), fit: BoxFit.cover),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ScreenAppLogo(),
                      Text(
                        'Comperio',
                        style: KAppNameTextStyle,
                      ),
                    ],
                  )),
                ),
                Flexible(
                  //fit: FlexFit.tight,
                  child: Container(
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 25, bottom: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Container(
                                  child: Text(
                                    "On a scale of 1 to 5, rate the overall performance of the teacher?",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 14.0,
                                    right: 14.0,
                                    top: 14,
                                    bottom: 5.0),
                                child: Container(
                                    child: Text(
                                  myFeedbackText,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 25.0),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                      child: Icon(
                                    myFeedback,
                                    color: myFeedbackColor,
                                    size: 120.0,
                                  )),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
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
                                padding: EdgeInsets.all(14.0),
                                child: Container(
                                    child: Text(
                                  "Your Rating: $sliderValue",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Container(
                                    height: 45.0,
                                    width: 80.0,
                                    child: RaisedButton(
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Color(0xFFf2fcfe),
                                          fontSize: 25.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Color(0xFF005C97),
                                      onPressed: () {},
                                    )),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

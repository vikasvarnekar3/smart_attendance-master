import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_attendance/pages/teacher/Profile/profile.dart';
import 'package:smart_attendance/pages/teacher/Previous_Lectures/previous_lectures.dart';
import 'package:smart_attendance/pages/teacher/Create_Lecture//generation_data.dart';
import 'package:smart_attendance/globals.dart' as globals;
import 'package:back_button_interceptor/back_button_interceptor.dart';
//import 'package:smart_attendance/services/validations.dart';
import 'package:smart_attendance/pages/welcome.dart';

class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => new _TeacherState();
}

class _TeacherState extends State<Teacher> {
//  void showInSnackBar(String value) {
//    _scaffoldKey.currentState
//        .showSnackBar(new SnackBar(content: new Text(value)));
//  }

//  void _showDialogPastData(List<DocumentSnapshot> list) {
//    // flutter defined function
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text(
//              "Looks like previous session was not closed properly. Don't click back or exit while we are building a new session for you."),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Refresh"),
//              onPressed: ()  {
//
//
////                clearPastData(list);
////                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
//    _showDialog(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
    return true;
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Teacher Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body:

//          new Center(
////            child: new Image.asset(
////              'images/white_snow.png',
////              width: 490.0,
////              height: 1200.0,
////              fit: BoxFit.fill,
////            ),
//          ),

            new ListView(
          children: <Widget>[
            new ListTile(
              // ignore: deprecated_member_use
              title: new FlatButton(
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
//                                globals.studentId.clear();

                        // ignore: deprecated_member_use
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          duration: new Duration(seconds: 20),
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Loading...")
                            ],
                          ),
                        ));

                        checkingPastStudentData(context);
                      }
                    } on SocketException catch (_) {
                      debugPrint('not connected');

                      // ignore: deprecated_member_use
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        duration: new Duration(seconds: 4),
                        content: new Row(
                          children: <Widget>[
                            new Text("Please check your internet connection!")
                          ],
                        ),
                      ));
                    }
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Start Lecture')),
            ),
            new ListTile(
              // ignore: deprecated_member_use
              title: new FlatButton(
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviousLectures()),
                        );
                      }
                    } on SocketException catch (_) {
                      debugPrint('not connected');

                      // ignore: deprecated_member_use
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        duration: new Duration(seconds: 4),
                        content: new Row(
                          children: <Widget>[
                            new Text("Please check your internet connection!")
                          ],
                        ),
                      ));
                    }
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Previous Lectures')),
            ),
            new ListTile(
              // ignore: deprecated_member_use
              title: new FlatButton(
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      }
                    } on SocketException catch (_) {
                      debugPrint('not connected');

                      // ignore: deprecated_member_use
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        duration: new Duration(seconds: 4),
                        content: new Row(
                          children: <Widget>[
                            new Text("Please check your internet connection!")
                          ],
                        ),
                      ));
                    }
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Profile')),
            )
          ],
        ));
  }
}

checkingPastStudentData(BuildContext context) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("attendance")
      .doc(globals.attendance_id)
      .collection("attendance")
      .get();

  debugPrint(" length : ${querySnapshot.docs.length}");

  if (querySnapshot.docs.length > 1) {
    globals.extraStudentDocumentId.clear();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      globals.extraStudentDocumentId
          .insert(i, "${querySnapshot.docs[i].documentID}");
    }
    debugPrint("${globals.extraStudentDocumentId[0]}");

    debugPrint(" length : ${globals.extraStudentDocumentId.length}");

    for (int i = 1; i < globals.extraStudentDocumentId.length; i++) {
      debugPrint(" deleting ${globals.extraStudentDocumentId[i]}");
      FirebaseFirestore.instance
          .collection("attendance")
          .doc("${globals.attendance_id}")
          .collection("attendance")
          .doc(globals.extraStudentDocumentId[i])
          .delete();
    }
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Generation()),
    );
  } else {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Generation()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_attendance/pages/student/Join_Lecture/Dashboard/info.dart';
import 'package:smart_attendance/pages/student/Join_Lecture/Dashboard/later.dart';
import 'package:smart_attendance/pages/student/Join_Lecture/Dashboard/present.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:smart_attendance/pages/student/home.dart';

class Lecture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LectureState();
  }
}
class LectureState extends State<Lecture> {


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

  bool myInterceptor(bool stopDefaultButtonEvent,RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    _showDialog(context);
    return true;
  }

  void _showDialog(BuildContext pageContext) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you want to quit lecture dashboard?"),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
Navigator.pop(pageContext);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Student()),
                );
              


              },
            ),
          ],
        );
      },
    );
  }













  int _selectedTab = 0;
  final _pageOptions = [
    Present(),
    Info(),
    LaterPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
          )),
      home: Scaffold(

        body: _pageOptions[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text('ATTENDANCE'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('INFO'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.update),
              title: Text('CHAT'),
            ),
          ],
        ),
      ),
    );
  }}
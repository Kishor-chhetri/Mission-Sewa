import 'package:flutter/material.dart';
import 'package:mission_app/Screens/welcome_screen.dart';
import 'package:mission_app/components/sign_in.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'package:mission_app/components/add_events.dart';

class EventScreen extends StatelessWidget {
  static const String id = 'event_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(context: context, builder: (context) => TaskScreen());
          },
          backgroundColor: Color(0xffeb1555),
          child: Icon(
            Icons.add,
            size: 32,
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black54,
              ),
              height: 170.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          imageUrl,
                        ),
                        radius: 55,
                        backgroundColor: Color(0xffeb1555),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedButton(
                        colour: Color(0xffeb1555),
                        title: 'Sign Out',
                        onPressed: () {
                          signOutGoogle();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }), ModalRoute.withName('/'));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.all(10),
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black54,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'All Events',
                  ),
                  Icon(
                    Icons.near_me,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'Near Me',
                  ),
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'Attending',
                  ),
                  Icon(
                    Icons.perm_contact_calendar,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'My Events',
                  ),
                ],
              ),
            ),
            // Container(
            //   child: ListView.builder(itemBuilder: )
            // ),
          ],
        ),
      ),
    );
  }
}

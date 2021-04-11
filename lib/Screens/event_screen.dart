import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/Screens/home.dart';
import 'package:mission_app/Screens/nearby_events.dart';
import 'package:mission_app/Screens/interested_events.dart';
import 'package:mission_app/Screens/my_events_screen.dart';
import 'package:mission_app/components/sign_in.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'package:mission_app/components/add_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_container.dart';
import 'welcome_screen.dart';

class EventScreen extends StatefulWidget {
  static const String id = 'event_screen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void eventsStream() async {
    await for (var snapshot in _firestore.collection('events').snapshots()) {
      for (var event in snapshot.docs) {
        print(event.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              builder: (context) => TaskScreen(),
            );
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
              // height: 150.0,
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
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
              child: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'Home',
                  ),
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
                    Icons.perm_contact_calendar,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'My Events',
                  ),
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'Interested Events',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                flex: 2,
                child: TabBarView(
                  children: [
                    HomeContainer(),
                    EventContainer(firestore: _firestore),
                    NearbyEvents(),
                    MyEvents(),
                    InterestedEvents(
                      firestore: _firestore,
                    ),
                  ],
                  controller: _tabController,
                ))
          ],
        ),
      ),
    );
  }
}

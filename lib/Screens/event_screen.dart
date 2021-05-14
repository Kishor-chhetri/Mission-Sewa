import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/Screens/home.dart';
import 'package:mission_app/Screens/interested_events.dart';
import 'package:mission_app/Screens/my_events_screen.dart';
import 'package:mission_app/Screens/welcome_screen.dart';
import 'package:mission_app/components/add_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_container.dart';
import 'nearby_event.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
User logUser;

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
    super.initState();
    getCurrentUser();
    _tabController = TabController(length: 5, vsync: this);
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        logUser = user;
        print(logUser.email);
      }
    } catch (e) {
      print(e);
    }
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
            FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: logUser.uid)
                .get()
                .then((value) => {
                      if (value.docs[0].data()["registered"])
                        {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            builder: (context) => TaskScreen(),
                          )
                        }
                      else
                        {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Approval of Admin Needed'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'If you have registered with all the necessary fields then it can takes up to a day or two. '),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text('For Further Enquiries'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'You can contatct the admin at : kishor.chhetri8848@gmail.com'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        }
                    });
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
              margin: EdgeInsets.all((15)),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black54,
              ),
              // height: 150.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                          future: _firestore
                              .collection('users')
                              .doc(logUser.uid)
                              .get(),
                          builder: (context, snapshot) {
                            return snapshot.data == null
                                ? Text("Loading")
                                : Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Text('${snapshot.data["full_name"]}',
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  );
                          }),
                    ],
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  GestureDetector(
                      onTap: () {
                        auth.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                      },
                      child: Icon(
                        Icons.logout,
                        color: Color(0xffeb1555),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.all(10),
              height: 50,
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
                    Icons.check_box,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'My Events',
                  ),
                  Icon(
                    Icons.perm_contact_calendar,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'Interested Events',
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: TabBarView(
                  children: [
                    HomeContainer(),
                    EventContainer(firestore: _firestore),
                    NearbyEvent(),
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

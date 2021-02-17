import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/components/sign_in.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'package:mission_app/components/add_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_screen.dart';

class EventScreen extends StatefulWidget {
  static const String id = 'event_screen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _firestore = FirebaseFirestore.instance;

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
                context: context, builder: (context) => TaskScreen());
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
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('events').snapshots(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0x00eb1555),
                            ),
                          );
                        }
                        final events = snapshot.data.docs;
                        List<EventCard> eventWidgets = [];
                        for (var event in events) {
                          final eventTitle = event.data()['title'];
                          final eventDescription = event.data()['description'];
                          final eventLocation = event.data()['event_location'];
                          final eventDate = event.data()['event_date'];
                          final eventId = event.data()['event_id'];
                          final publisherId = event.data()['publisher_id'];

                          final eventWidget = EventCard(
                              title: eventTitle,
                              publisher: publisherId,
                              date: eventDate,
                              location: eventLocation,
                              description: eventDescription);
                          eventWidgets.add(eventWidget);
                        }
                        return Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            children: eventWidgets,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String publisher;
  final String location;
  final String description;
  final Timestamp date;

  EventCard(
      {@required this.title,
      @required this.publisher,
      @required this.date,
      @required this.location,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.black54,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '$publisher',
            style: TextStyle(
              color: Color(0xffeb1555),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text('$location ,'),
              SizedBox(
                width: 10,
              ),
              Text(
                '$date',
                style: TextStyle(
                  fontSize: 5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            ' ' '  $description',
            style: TextStyle(
              fontSize: 15,
              wordSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/Screens/new_screen.dart';
import 'package:mission_app/components/sign_in.dart';
import 'event_card.dart';

class MyEvents extends StatefulWidget {
  static const String id = "my_events_screen";

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final events = snapshot.data.docs;
          List<EventCard> eventWidgets = [];
          for (var event in events) {
            if (event.data()["publisher_id"] == email) {
              final eventTitle = event.data()['title'];
              final eventDescription = event.data()['description'];
              final eventLocation = event.data()['event_location'];
              final eventDate = event.data()['event_date'];
              final eventTime = event.data()['event_time'];
              var date = DateTime.parse(eventDate.toDate().toString());
              final docId = event.id;
              final publisherId = event.data()['publisher_id'];
              final eventWidget = EventCard(
                  btnName: "Nth",
                  btnFun: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return NewScreen(docId: docId);
                        },
                      ),
                    );
                  },
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return NewScreen(docId: docId);
                        },
                      ),
                    );
                  },
                  document: docId,
                  title: eventTitle,
                  publisher: publisherId,
                  date: date,
                  time: eventTime,
                  location: eventLocation,
                  description: eventDescription);

              eventWidgets.add(eventWidget);
            }
          }
          return ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: eventWidgets);
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/components/sign_in.dart';

import 'event_card.dart';

class InterestedEvents extends StatefulWidget {
  static const String id = "interested_events";
  const InterestedEvents({
    Key key,
    @required FirebaseFirestore firestore,
    this.document,
  })  : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;
  final String document;

  @override
  _InterestedEventsState createState() => _InterestedEventsState();
}

class _InterestedEventsState extends State<InterestedEvents> {
  FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    firestore = FirebaseFirestore.instance;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('events').snapshots(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            final events = snapshot.data.docs;
            List<EventCard> eventWidgets = [];
            for (var event in events) {
              if (event.data()["interested"] == null
                  ? false
                  : event.data()["interested"].contains(email)) {
                final eventTitle = event.data()['title'];
                final eventDescription = event.data()['description'];
                final eventLocation = event.data()['event_location'];
                final eventDate = event.data()['event_date'];
                final eventTime = event.data()['event_time'];
                var date = DateTime.parse(eventDate.toDate().toString());
                final docId = event.id;
                final publisherId = event.data()['publisher_id'];
                final eventWidget = EventCard(
                    btnName: "Cancel",
                    btnFun: () {
                      FirebaseFirestore.instance
                          .collection("events")
                          .doc("${event.id}")
                          .update({
                        "interested": FieldValue.arrayRemove([email])
                      });
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
          }),
    );
  }
}

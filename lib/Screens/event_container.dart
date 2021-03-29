import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'event_card.dart';

class EventContainer extends StatefulWidget {
  const EventContainer({
    Key key,
    @required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;

  @override
  _EventContainerState createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: widget._firestore.collection('events').snapshots(),
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
                final eventTitle = event.data()['title'];
                final eventDescription = event.data()['description'];
                final eventLocation = event.data()['event_location'];
                final eventDate = event.data()['event_date'];
                final eventTime = event.data()['event_time'];
                var date = DateTime.parse(eventDate.toDate().toString());
                final docId = event.id;
                final publisherId = event.data()['publisher_id'];
                final eventWidget = EventCard(
                    document: docId,
                    title: eventTitle,
                    publisher: publisherId,
                    date: date,
                    time: eventTime,
                    location: eventLocation,
                    description: eventDescription);
                eventWidgets.add(eventWidget);
              }
              return Expanded(
                child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    children: eventWidgets),
              );
            },
          ),
        ],
      ),
    );
  }
}

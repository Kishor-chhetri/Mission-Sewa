import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'event_card.dart';
import 'event_screen.dart';

class EventContainer extends StatefulWidget {
  const EventContainer({
    Key key,
    @required FirebaseFirestore firestore,
    this.document,
  })  : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;
  final String document;

  @override
  _EventContainerState createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  DateTime eventDate = DateTime.now();
  String query = "";

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: eventDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != eventDate)
      setState(() {
        eventDate = picked;
      });
  }

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
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search Events...',
            ),
            onChanged: (val) {
              setState(() {
                query = val.toLowerCase();
              });
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: (query != "" && query != null)
                ? FirebaseFirestore.instance
                    .collection('events')
                    .where('searchKeywords', arrayContains: query)
                    .snapshots()
                : FirebaseFirestore.instance.collection('events').snapshots(),
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
                final phoneNumber = event.data()['phone_number'];
                final eventDates = event.data()['event_date'];
                final eventTime = event.data()['event_time'];
                var date = DateTime.parse(eventDates.toDate().toString());
                final docId = event.id;
                final publisherId = event.data()['publisher_id'];
                final evt = event.data()['event_type'];
                final eventWidget = EventCard(
                    btnName:
                        eventDates.toDate().difference(eventDate).inDays < 1
                            ? 'Finished'
                            : event.data()['interested'].contains(logUser.email)
                                ? 'Joined'
                                : 'Join',
                    btnFun: () {
                      if (eventDate != null) {
                        if (eventDates.toDate().difference(eventDate).inDays >
                            1) {
                          if ((int.parse(event.data()["volunteer_number"])) >
                              ((event.data()["interested"]).length)) {
                            FirebaseFirestore.instance
                                .collection("events")
                                .doc("${event.id}")
                                .update({
                              "interested":
                                  FieldValue.arrayUnion([logUser.email])
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .where('email', isEqualTo: logUser.email)
                                .get()
                                .then((value) => value.docs.forEach((element) {
                                      element.reference.update({
                                        'interested_types':
                                            FieldValue.arrayUnion([evt])
                                      });
                                    }));
                          } else {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      height: 200,
                                      child: AlertDialog(
                                        title: Text(
                                            "Sorry, all seats are filled."),
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Okay")),
                                        ],
                                        elevation: 24.0,
                                      ),
                                    ),
                                  );
                                });
                          }
                        }
                      }
                      if ((int.parse(event.data()["volunteer_number"])) >
                          ((event.data()["interested"]).length)) {
                        FirebaseFirestore.instance
                            .collection("events")
                            .doc("${event.id}")
                            .update({
                          "interested": FieldValue.arrayUnion([logUser.email])
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: logUser.email)
                            .get()
                            .then((value) => value.docs.forEach((element) {
                                  element.reference.update({
                                    'interested_types':
                                        FieldValue.arrayUnion([evt])
                                  });
                                }));
                      } else {
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Container(
                                  height: 200,
                                  child: AlertDialog(
                                    title: Text("Sorry, all seats are filled."),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Okay")),
                                    ],
                                    elevation: 24.0,
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    document: docId,
                    title: eventTitle,
                    publisher: publisherId,
                    phoneNumber: phoneNumber,
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


import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_app/constants.dart';
import 'package:mission_app/modules/models/event_modals.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'event_card.dart';
import 'event_screen.dart';

class NearbyEvents extends StatefulWidget {
  static const String id = "nearby_events";
  @override
  _NearbyEventsState createState() => _NearbyEventsState();
}

class _NearbyEventsState extends State<NearbyEvents> {
  Geolocator geoLocator;
  Position position;
  double eventLat;
  double eventLong;
  double userLat;
  double userLong;
  double distance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  DateTime eventDate = DateTime.now();
  String city;
  String district;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  void getLocation() async {
    var longAndLat = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      userLat = longAndLat.latitude;
      userLong = longAndLat.longitude;
    });
  }

  Future<List<double>> getEventLocation() async {
    http.Response response = await http.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$city+$district+Nepal&key=$kApiKey');
    var data = response.body;
    var eventLongitude =
        jsonDecode(data)["results"][0]["geometry"]["location"]["lng"];
    var eventLatitude =
        jsonDecode(data)["results"][0]["geometry"]["location"]["lat"];

    return [eventLongitude, eventLatitude];
  }

  Future<double> getDistance() async {
    List<double> longAndLat = await getEventLocation();
    var p = 0.017453292519943295;
    print("$longAndLat , $userLong, $userLat");
    var c = cos;
    var a = 0.5 -
        c((longAndLat[1] - userLat) * p) / 2 +
        c(userLat * p) *
            c(longAndLat[1] * p) *
            (1 - c((longAndLat[0] - userLong) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    geoLocator = Geolocator();
    position = Position();
    getLocation();
    getEventLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          final events = snapshot.data.docs;
          List<Card> eventWidgets = [];
          for (var event in events) {
            distance() async {
              return await getDistance();
            }

            final eventTitle = event.data()['title'];
            final eventDescription = event.data()['description'];
            city = event.data()['event_location'];
            district = event.data()['event_location'];
            final phoneNumber = event.data()['phone_number'];
            final eventDates = event.data()['event_date'];
            final eventTime = event.data()['event_time'];
            var date = DateTime.parse(eventDates.toDate().toString());
            final docId = event.id;
            final publisherId = event.data()['publisher_id'];
            final eventWidget = Card(
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: logUser.email == publisherId
                      ? Colors.black54
                      : Colors.black54,
                ),
                // ignore: missing_return
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              eventTitle,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                if (eventDates
                                        .toDate()
                                        .difference(eventDate)
                                        .inDays >
                                    0.5) {
                                  if ((int.parse(
                                          event.data()["volunteer_number"])) >
                                      ((event.data()["interested"]).length)) {
                                    FirebaseFirestore.instance
                                        .collection("events")
                                        .doc("$docId")
                                        .update({
                                      "interested":
                                          FieldValue.arrayUnion([logUser.email])
                                    });
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
                              },
                              color: eventDates
                                          .toDate()
                                          .difference(eventDate)
                                          .inDays <
                                      1
                                  ? Colors.grey
                                  : event
                                          .data()['interested']
                                          .contains(logUser.email)
                                      ? Colors.blueAccent
                                      : Color(0xffeb1555),
                              child: Text(
                                eventDates
                                            .toDate()
                                            .difference(eventDate)
                                            .inDays <
                                        1
                                    ? 'Finished'
                                    : event
                                            .data()['interested']
                                            .contains(logUser.email)
                                        ? 'Joined'
                                        : 'Join',
                              ))
                        ]),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.data()["publisher_id"],
                          style: TextStyle(
                            color: Color(0xffeb1555),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_searching),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${distance() == null ? "calculating......" : distance()} km near",
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xffeb1555)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(city),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$date',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Text("Event time: " + eventTime),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      ' '
                      '  $eventDescription',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        wordSpacing: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "For Further Details:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        wordSpacing: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "Contact Number: ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 15,
                            wordSpacing: 1.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print(phoneNumber);
                            setState(() {
                              makePhoneCall('tel: $phoneNumber');
                            });
                          },
                          child: Text(
                            '$phoneNumber',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              wordSpacing: 1.5,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
            eventWidgets.add(eventWidget);
          }
          return ListView(children: eventWidgets);
        },
      ),
    );
  }
}

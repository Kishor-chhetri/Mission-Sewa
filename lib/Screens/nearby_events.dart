import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_app/modules/models/event_modals.dart';
import 'package:intl/intl.dart';

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
  List<QueryDocumentSnapshot> cityName = List<QueryDocumentSnapshot>();
  double km;
  DateTime eventDate = DateTime.now();

  @override
  void initState() {
    geoLocator = Geolocator();
    position = Position();
    getLocation();
    super.initState();
  }

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: StreamBuilder<QuerySnapshot>(
              stream: fireStore
                  .collection("events")
                  .where("publisher_id", isNotEqualTo: logUser.email)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return CircularProgressIndicator();
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                cityName = snap.data.docs.toList();

                return ListView.builder(
                  itemCount: cityName.length,
                  itemBuilder: (context, index) {
                    final eventDates = snap.data.docs[index]['event_date'];
                    final String formatted = formatter.format(DateTime.parse(
                        snap.data.docs[index]["event_date"]
                            .toDate()
                            .toString()));
                    return FutureBuilder(
                      future: getDistance(cityName[index]["city_name"]),
                      builder: (context, snapshot) {
                        return Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: logUser.email ==
                                    snap.data.docs[index]["publisher_id"]
                                ? Colors.black54
                                : Colors.black54,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snap.data.docs[index]["title"]
                                            .toString(),
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        onPressed: () {
                                          if (eventDates
                                                  .toDate()
                                                  .difference(eventDate)
                                                  .inDays >
                                              0.5) {
                                            if ((int.parse(snap.data.docs[index]
                                                    ["volunteer_number"])) >
                                                ((snap.data.docs[index]
                                                        ["interested"])
                                                    .length)) {
                                              FirebaseFirestore.instance
                                                  .collection("events")
                                                  .doc(
                                                      "${snap.data.docs[index].id}")
                                                  .update({
                                                "interested":
                                                    FieldValue.arrayUnion(
                                                        [logUser.email])
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
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Okay")),
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
                                            : snap.data
                                                    .docs[index]['interested']
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
                                              : snap.data
                                                      .docs[index]['interested']
                                                      .contains(logUser.email)
                                                  ? 'Joined'
                                                  : 'Join',
                                        ))
                                  ]),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snap.data.docs[index]["publisher_id"],
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
                                        "${snapshot.data == null ? "calculating......" : snapshot.data.toStringAsFixed(2)} km near",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xffeb1555)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(snap.data.docs[index]["city_name"]),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formatted,
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text("Event time: " +
                                      snap.data.docs[index]['event_time']),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                ' '
                                '  ${snap.data.docs[index]['description']}',
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
                                      print(snap.data.docs[index]
                                          ["phone_number"]);
                                      setState(() {
                                        makePhoneCall(
                                            'tel: ${snap.data.docs[index]["phone_number"]}');
                                      });
                                    },
                                    child: Text(
                                      '${snap.data.docs[index]["phone_number"]}',
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
                        );
                      },
                    );
                  },
                );
              })),
    );
  }

  getDistance(String cityName) async {
    List<double> longAndLat = await _go(cityName);
    var p = 0.017453292519943295;
    print("$longAndLat, $eventLat, $userLong, $userLat");
    var c = cos;
    var a = 0.5 -
        c((longAndLat[0] - userLat) * p) / 2 +
        c(userLat * p) *
            c(longAndLat[0] * p) *
            (1 - c((longAndLat[1] - userLong) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  Future<List<double>> _go(String cityNames) async {
    Map<String, dynamic> myJson =
        jsonDecode(await rootBundle.loadString('images/longAndLat.json'));
    eventLong = myJson["$cityNames"]["Long"];
    eventLat = myJson["$cityNames"]["Lat"];
    return [eventLat, eventLong];
  }

  void getLocation() async {
    var longAndLat = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      userLat = longAndLat.latitude;
      userLong = longAndLat.longitude;
    });
  }
}

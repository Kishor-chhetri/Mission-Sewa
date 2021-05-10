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

class NearbyEvent extends StatefulWidget {
  static const String id = "nearby_event";
  @override
  _NearbyEventState createState() => _NearbyEventState();
}

class _NearbyEventState extends State<NearbyEvent> {
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

  @override
  void initState() {
    geoLocator = Geolocator();
    position = Position();
    getLocation();
    getEventLocation();
    getDistance();
    super.initState();
  }

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

  getDistance() async {
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
    var result = 12742 * asin(sqrt(a));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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

          return ListView.builder(
            itemCount: snap.data.docs.length,
            itemBuilder: (context, index) {
              final eventDates = snap.data.docs[index]['event_date'];
              final String formatted = formatter.format(DateTime.parse(
                  snap.data.docs[index]["event_date"].toDate().toString()));
              city = snap.data.docs[index]['city_name'];
              district = snap.data.docs[index]['district'];

              return FutureBuilder(
                future: getDistance(),
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color:
                          logUser.email == snap.data.docs[index]["publisher_id"]
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
                                  snap.data.docs[index]["title"].toString(),
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
                                      if ((int.parse(snap.data.docs[index]
                                              ["volunteer_number"])) >
                                          ((snap.data.docs[index]["interested"])
                                              .length)) {
                                        FirebaseFirestore.instance
                                            .collection("events")
                                            .doc("${snap.data.docs[index].id}")
                                            .update({
                                          "interested": FieldValue.arrayUnion(
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
                                      : snap.data.docs[index]['interested']
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
                                        : snap.data.docs[index]['interested']
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
                                print(snap.data.docs[index]["phone_number"]);
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
                    // ignore: missing_return
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

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
  List<QueryDocumentSnapshot> cityName;
  double km;
  @override
  void initState() {
    geoLocator = Geolocator();
    position = Position();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: fireStore.collection("events").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                cityName = snapshot.data.docs.toList();
                return ListView.builder(
                  itemCount: cityName.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: getDistance(cityName[index]["city_name"]),
                      builder: (context, snapshot) {
                        return Card(
                          child: Text(
                            "${snapshot.data} km near",
                            style: TextStyle(fontSize: 25),
                          ),
                        );
                      },
                    );
                  },
                );
              })),
    );
  }

  Future<double> getDistance(String cityName) async {
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

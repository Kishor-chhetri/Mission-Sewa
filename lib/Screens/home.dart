import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/Screens/event_screen.dart';
import 'event_card.dart';
import 'package:intl/intl.dart';

class HomeContainer extends StatefulWidget {
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Text("Recently Added",
                style: TextStyle(
                  fontSize: 20,
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection("events")
                      .orderBy("time_stamp", descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return Text("Loading");
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    return Container(
                      height: 350,
                      child: PageView.builder(
                          pageSnapping: false,
                          physics: PageScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 2 != null ? 2 : Text("Loading"),
                          itemBuilder: (context, index) {
                            final String formatted = formatter.format(
                                DateTime.parse(snap
                                    .data.docs[index]["event_date"]
                                    .toDate()
                                    .toString()));
                            final eventDates =
                                snap.data.docs[index]["event_date"];
                            // ignore: missing_return, missing_return
                            DateTime eventDate = DateTime.now();

                            return ListView(children: [
                              EventCard(
                                  btnName: eventDates
                                              .toDate()
                                              .difference(eventDate)
                                              .inDays <
                                          1
                                      ? 'Finished'
                                      : snap.data.docs[index]["interested"]
                                              .contains(logUser.email)
                                          ? 'Joined'
                                          : 'Join',
                                  btnFun: () {
                                    if (eventDate != null) {
                                      if (eventDates
                                              .toDate()
                                              .difference(eventDate)
                                              .inDays >
                                          1) {
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
                                                            child:
                                                                Text("Okay")),
                                                      ],
                                                      elevation: 24.0,
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      }
                                    }
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
                                  },
                                  title: snap.data.docs[index]["title"],
                                  publisher: snap.data.docs[index]
                                      ["publisher_id"],
                                  date: snap.data.docs[index]["event_date"]
                                      .toDate(),
                                  time: snap.data.docs[index]['event_time'],
                                  location: snap.data.docs[index]['city_name'],
                                  description: snap.data.docs[index]
                                      ['description'],
                                  // document: null,
                                  phoneNumber: snap.data.docs[index]
                                      ['phone_number'])
                            ]);
                          }),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Recommended",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                 height: 400,
                child: FutureBuilder(
                  future: firestore.collection('users').doc(logUser.uid).get(),
                  builder: (context, snapshot) {
                    return snapshot.data == null
                        ? Center(
                            child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ))
                        : snapshot.data["interested_types"].isEmpty
                            ? StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('events')
                            .snapshots(),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return Text("Loading");
                          }
                          if (snap.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }
                          return Container(
                            height: 350,
                            child: PageView.builder(
                                pageSnapping: false,
                                physics: PageScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snap.data.docs.length,
                                itemBuilder: (context, index) {
                                  final String formatted = formatter
                                      .format(DateTime.parse(snap.data
                                      .docs[index]["event_date"]
                                      .toDate()
                                      .toString()));
                                  final eventDates = snap
                                      .data.docs[index]["event_date"];
                                  DateTime eventDate = DateTime.now();

                                  return ListView(children: [
                                    EventCard(
                                        btnName: eventDates.toDate().difference(eventDate).inDays <
                                            1
                                            ? 'Finished'
                                            : snap
                                            .data
                                            .docs[index]
                                        ["interested"]
                                            .contains(
                                            logUser.email)
                                            ? 'Joined'
                                            : 'Join',
                                        btnFun: () {
                                          if (eventDate != null) {
                                            if (eventDates
                                                .toDate()
                                                .difference(
                                                eventDate)
                                                .inDays >
                                                1) {
                                              if ((int.parse(snap.data
                                                  .docs[index][
                                              "volunteer_number"])) >
                                                  ((snap.data.docs[
                                                  index][
                                                  "interested"])
                                                      .length)) {
                                                FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                    "events")
                                                    .doc(
                                                    "${snap.data.docs[index].id}")
                                                    .update({
                                                  "interested":
                                                  FieldValue
                                                      .arrayUnion([
                                                    logUser.email
                                                  ])
                                                });
                                              } else {
                                                showDialog(
                                                    barrierDismissible:
                                                    true,
                                                    context: context,
                                                    builder: (context) {
                                                      return Center(
                                                        child:
                                                        Container(
                                                          height: 200,
                                                          child:
                                                          AlertDialog(
                                                            title: Text(
                                                                "Sorry, all seats are filled."),
                                                            actions: [
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child:
                                                                  Text("Okay")),
                                                            ],
                                                            elevation:
                                                            24.0,
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            }
                                          }
                                          if ((int.parse(snap
                                              .data.docs[index][
                                          "volunteer_number"])) >
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
                                                barrierDismissible:
                                                true,
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child: Container(
                                                      height: 200,
                                                      child:
                                                      AlertDialog(
                                                        title: Text(
                                                            "Sorry, all seats are filled."),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed:
                                                                  () {
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
                                        },
                                        title: snap.data.docs[index]
                                        ["title"],
                                        publisher: snap.data.docs[index]
                                        ["publisher_id"],
                                        date: snap.data
                                            .docs[index]["event_date"]
                                            .toDate(),
                                        time: snap.data.docs[index]
                                        ['event_time'],
                                        location: snap.data.docs[index]
                                        ['city_name'],
                                        description: snap.data.docs[index]
                                        ['description'],
                                        // document: null,
                                        phoneNumber: snap.data.docs[index]
                                        ['phone_number'])
                                  ]);
                                }),
                          );
                        })
                            : StreamBuilder<QuerySnapshot>(
                                stream: firestore
                                    .collection('events')
                                    .where("event_type",
                                        whereIn:
                                            snapshot.data["interested_types"])
                                    .limit(5)
                                    .snapshots(),
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return Text("Loading");
                                  }
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Loading");
                                  }
                                  return Container(
                                    height: 350,
                                    child: PageView.builder(
                                        pageSnapping: false,
                                        physics: PageScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snap.data.docs.length,
                                        itemBuilder: (context, index) {
                                          final String formatted = formatter
                                              .format(DateTime.parse(snap.data
                                                  .docs[index]["event_date"]
                                                  .toDate()
                                                  .toString()));
                                          final eventDates = snap
                                              .data.docs[index]["event_date"];
                                          DateTime eventDate = DateTime.now();

                                          return ListView(children: [
                                            EventCard(
                                                btnName: eventDates.toDate().difference(eventDate).inDays <
                                                        1
                                                    ? 'Finished'
                                                    : snap
                                                            .data
                                                            .docs[index]
                                                                ["interested"]
                                                            .contains(
                                                                logUser.email)
                                                        ? 'Joined'
                                                        : 'Join',
                                                btnFun: () {
                                                  if (eventDate != null) {
                                                    if (eventDates
                                                            .toDate()
                                                            .difference(
                                                                eventDate)
                                                            .inDays >
                                                        1) {
                                                      if ((int.parse(snap.data
                                                                  .docs[index][
                                                              "volunteer_number"])) >
                                                          ((snap.data.docs[
                                                                      index][
                                                                  "interested"])
                                                              .length)) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "events")
                                                            .doc(
                                                                "${snap.data.docs[index].id}")
                                                            .update({
                                                          "interested":
                                                              FieldValue
                                                                  .arrayUnion([
                                                            logUser.email
                                                          ])
                                                        });
                                                      } else {
                                                        showDialog(
                                                            barrierDismissible:
                                                                true,
                                                            context: context,
                                                            builder: (context) {
                                                              return Center(
                                                                child:
                                                                    Container(
                                                                  height: 200,
                                                                  child:
                                                                      AlertDialog(
                                                                    title: Text(
                                                                        "Sorry, all seats are filled."),
                                                                    actions: [
                                                                      FlatButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text("Okay")),
                                                                    ],
                                                                    elevation:
                                                                        24.0,
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      }
                                                    }
                                                  }
                                                  if ((int.parse(snap
                                                              .data.docs[index][
                                                          "volunteer_number"])) >
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
                                                        barrierDismissible:
                                                            true,
                                                        context: context,
                                                        builder: (context) {
                                                          return Center(
                                                            child: Container(
                                                              height: 200,
                                                              child:
                                                                  AlertDialog(
                                                                title: Text(
                                                                    "Sorry, all seats are filled."),
                                                                actions: [
                                                                  FlatButton(
                                                                      onPressed:
                                                                          () {
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
                                                },
                                                title: snap.data.docs[index]
                                                    ["title"],
                                                publisher: snap.data.docs[index]
                                                    ["publisher_id"],
                                                date: snap.data
                                                    .docs[index]["event_date"]
                                                    .toDate(),
                                                time: snap.data.docs[index]
                                                    ['event_time'],
                                                location: snap.data.docs[index]
                                                    ['city_name'],
                                                description: snap.data.docs[index]
                                                    ['description'],
                                                // document: null,
                                                phoneNumber: snap.data.docs[index]
                                                    ['phone_number'])
                                          ]);
                                        }),
                                  );
                                });
                  },
                ))
          ],
        ),
      ),
    );
  }
}

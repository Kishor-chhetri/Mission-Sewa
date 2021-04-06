import 'package:flutter/material.dart';
import 'package:mission_app/Screens/event_card.dart';
import 'package:mission_app/components/add_events.dart';
import 'package:mission_app/components/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mission_operation.dart';

class EventModel {
  String cityName;
  String description;
  String eventDate;
  String eventId;
  String eventLocation;
  String eventTime;
  List<Interested> interested;
  String publisherId;
  List<SearchKeywords> searchKeywords;
  String streetName;
  String title;
  String volunteerNumber;

  EventModel(
      {this.cityName,
      this.description,
      this.eventDate,
      this.eventId,
      this.eventLocation,
      this.eventTime,
      this.interested,
      this.publisherId,
      this.searchKeywords,
      this.streetName,
      this.title,
      this.volunteerNumber});

  EventModel.fromJson(Map<String, dynamic> json) {
    cityName = json['city_name'];
    description = json['description'];
    eventDate = json['event_date'];
    eventId = json['event_id'];
    eventLocation = json['event_location'];
    eventTime = json['event_time'];
    if (json['interested'] != null) {
      interested = new List<Interested>();
      json['interested'].forEach((v) {
        interested.add(new Interested.fromJson(v));
      });
    }
    publisherId = json['publisher_id'];
    if (json['searchKeywords'] != null) {
      searchKeywords = new List<SearchKeywords>();
      json['searchKeywords'].forEach((v) {
        searchKeywords.add(new SearchKeywords.fromJson(v));
      });
    }
    streetName = json['street_name'];
    title = json['title'];
    volunteerNumber = json['volunteer_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.cityName;
    data['description'] = this.description;
    data['event_date'] = this.eventDate;
    data['event_id'] = this.eventId;
    data['event_location'] = this.eventLocation;
    data['event_time'] = this.eventTime;
    if (this.interested != null) {
      data['interested'] = this.interested.map((v) => v.toJson()).toList();
    }
    data['publisher_id'] = this.publisherId;
    if (this.searchKeywords != null) {
      data['searchKeywords'] =
          this.searchKeywords.map((v) => v.toJson()).toList();
    }
    data['street_name'] = this.streetName;
    data['title'] = this.title;
    data['volunteer_number'] = this.volunteerNumber;
    return data;
  }
}

class Interested {
  String s0;

  Interested({this.s0});

  Interested.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    return data;
  }
}

class SearchKeywords {
  String s0;
  String s1;

  SearchKeywords({this.s0, this.s1});

  SearchKeywords.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    s1 = json['1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['1'] = this.s1;
    return data;
  }
}

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {@required this.hintText,
      this.keyType,
      this.maxLine,
      @required this.onChange});

  final String hintText;
  final TextInputType keyType;
  final int maxLine;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: TextField(
        onChanged: onChange,
        keyboardType: keyType,
        maxLines: maxLine,
        autofocus: false,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          enabled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffeb1555),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffeb1555),
            ),
          ),
          hintText: hintText,
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}

class flatBtn extends StatelessWidget {
  const flatBtn({
    Key key,
    this.widget,
    @required this.btnFun,
    @required this.btnName,
    @required this.noOfVolunteers,
    @required this.title,
    @required this.description,
    @required this.cityName,
    @required this.streetName,
    @required this.document,
    @required this.phoneNumber,
  }) : super(key: key);

  final EventCard widget;
  final Function btnFun;
  final String btnName;
  final String title;
  final String description;
  final String cityName;
  final String streetName;
  final String noOfVolunteers;
  final String phoneNumber;
  final String document;

  @override
  Widget build(BuildContext context) {
    MissionOperation missionOperation = new MissionOperation();
    return FlatButton(
        child: email == widget.publisher
            ? PopupMenuButton(
                onSelected: (value) {
                  if (value == "Edit") {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) => TaskScreen(
                              title: title,
                              description: description,
                              cityName: cityName,
                              noOfVolunters: noOfVolunteers,
                              streetName: "Koteshwor",
                            ));
                  } else {
                    missionOperation.deleteEvent(document);
                  }
                },
                onCanceled: () {
                  print('cancelled!');
                },
                child: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: "Edit",
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              Text("Edit"),
                            ],
                          )),
                      PopupMenuItem(
                          value: "Delete",
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              Text("Delete"),
                            ],
                          ))
                    ])
            : RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: widget.btnName == "Join"
                    ? Color(0xffeb1555)
                    : widget.btnName == "Finished"
                        ? Colors.grey
                        : Colors.blueAccent,
                onPressed: btnFun,
                child: Text(btnName),
              ));
  }
}



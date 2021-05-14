import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/Screens/event_screen.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'package:mission_app/modules/models/event_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';

class TaskScreen extends StatefulWidget {
  static const String id = "add_events";
  final String title;
  final String description;
  final String cityName;
  final String district;
  final String streetName;
  final String noOfVolunters;
  final String phoneNumber;

  TaskScreen(
      {this.title,
      this.district,
      this.description,
      this.cityName,
      this.streetName,
      this.noOfVolunters,
      this.phoneNumber});
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _fireStore = FirebaseFirestore.instance;

  DateTime eventDate = DateTime.now();

  String selectedEventType = 'Other';

  String eventCity;

  String eventStreet;

  String eventTitle;

  String volunteerNumber;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String eventDescription;

  String phoneNumber;

  String cityName;

  String district;

  String publisherId = logUser.email.toString();

  String _selectedTime() {
    return "${selectedTime.hour}:${selectedTime.minute}";
  }

  setSearchParam(String title) {
    List<String> searchKeys = List();
    String temp = "";
    for (int i = 0; i < title.length; i++) {
      temp = "";
      for (int j = i; j < title.length; j++) {
        temp = temp + title[j].toLowerCase();
        if (temp != " ") {
          searchKeys.add(temp);
        }
      }
    }
    return searchKeys;
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String city in eventType) {
      var newItem = DropdownMenuItem(child: Text(city), value: city);
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

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

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    // ignore: unrelated_type_equality_checks
    if (picked != null && picked != eventDate)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            Text(
              'Create New Event',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFieldWidget(
              hintText: widget.title == null ? "Title" : '${widget.title}',
              maxLine: 1,
              onChange: (value) {
                eventTitle = value;
              },
            ),
            TextFieldWidget(
              hintText: widget.description == null
                  ? "Description"
                  : '${widget.description}',
              keyType: TextInputType.multiline,
              maxLine: 5,
              onChange: (value) {
                eventDescription = value;
              },
            ),
            TextFieldWidget(
              hintText:
                  widget.cityName == null ? "City Name" : '${widget.cityName}',
              keyType: TextInputType.multiline,
              maxLine: 1,
              onChange: (value) {
                eventCity = value;
              },
            ),
            TextFieldWidget(
              hintText:
                  widget.district == null ? "District" : '${widget.district}',
              keyType: TextInputType.multiline,
              maxLine: 1,
              onChange: (value) {
                district = value;
              },
            ),
            TextFieldWidget(
              hintText: widget.phoneNumber == null
                  ? "Phone Number"
                  : '${widget.phoneNumber}',
              keyType: TextInputType.number,
              maxLine: 1,
              onChange: (value) {
                phoneNumber = value;
              },
            ),
            TextFieldWidget(
              hintText: widget.noOfVolunters == null
                  ? "No Of Volunteers"
                  : '${widget.noOfVolunters}',
              keyType: TextInputType.number,
              maxLine: 1,
              onChange: (value) {
                volunteerNumber = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Select Event Type"),
                DropdownButton<String>(
                    value: selectedEventType,
                    items: getDropdownItems(),
                    onChanged: (value) {
                      setState(() {
                        selectedEventType = value;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RoundedButton(
                  onPressed: () => selectDate(context),
                  title: 'Select Event Date',
                ),
                Text("${eventDate.toLocal()}".split(' ')[0]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RoundedButton(
                  onPressed: () => selectTime(context),
                  title: 'Select Event Time',
                ),
                Text("${selectedTime.hour}:${selectedTime.minute}"
                    .split(' ')[0]),
              ],
            ),
            RoundedButton(
              colour: Color(0xffeb1555),
              title: 'Create Event',
              onPressed: () {
                if (eventTitle != null &&
                    eventDescription != null &&
                    eventDate != null &&
                    eventCity != null &&
                    selectedEventType != null &&
                    phoneNumber != null &&
                    volunteerNumber != null &&
                    _selectedTime() != null) {
                  _fireStore.collection('events').add({
                    'title': eventTitle,
                    'description': eventDescription,
                    'event_date': eventDate,
                    'city_name': eventCity,
                    'street_name': eventStreet,
                    'event_time': _selectedTime(),
                    'publisher_id': publisherId,
                    'event_location': eventCity,
                    'volunteer_number': volunteerNumber,
                    'interested': [],
                    'searchKeywords': setSearchParam(eventTitle),
                    'phone_number': phoneNumber,
                    'time_stamp': DateTime.now().microsecondsSinceEpoch,
                    'event_type': selectedEventType,
                    'district': district,
                  });
                  Navigator.pop(context);
                } else {
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Container(
                            height: 200,
                            child: AlertDialog(
                              title: Text("Fill up the empty fields."),
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
            ),
          ],
        ),
      ),
    );
  }
}

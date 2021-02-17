import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'package:mission_app/components/city_name_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;

class TaskScreen extends StatefulWidget {
  static const String id = "add_events";

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _firestore = FirebaseFirestore.instance;

  DateTime eventDate = DateTime.now();

  String selectedCity = 'Kathmandu';

  String eventTitle;

  String eventDescription;

  int eventId = 0;

  String publisherId = email;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String city in cityList) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  hintText: 'Title',
                  maxLine: 1,
                  onChange: (value) {
                    eventTitle = value;
                  },
                ),
                TextFieldWidget(
                  hintText: 'Description',
                  keyType: TextInputType.multiline,
                  maxLine: 5,
                  onChange: (value) {
                    eventDescription = value;
                  },
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
                  children: [
                    Text('Select City'),
                    SizedBox(
                      width: 15,
                    ),
                    DropdownButton<String>(
                        value: selectedCity,
                        items: getDropdownItems(),
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        }),
                  ],
                ),
                RoundedButton(
                  colour: Color(0xffeb1555),
                  title: 'Create Event',
                  onPressed: () {
                    _firestore.collection('events').add({
                      'title': eventTitle,
                      'description': eventDescription,
                      'event_date': eventDate,
                      'publisher_id': publisherId,
                      'event_id': eventId,
                      'event_location': selectedCity,
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

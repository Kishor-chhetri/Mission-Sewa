import 'package:flutter/material.dart';
import 'package:mission_app/components/rounded_button.dart';

class TaskScreen extends StatelessWidget {

  static const String id = "add_events";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create New Event',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              autofocus: false,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            RoundedButton(
              colour: Color(0xffeb1555),
              title: 'Create Event',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

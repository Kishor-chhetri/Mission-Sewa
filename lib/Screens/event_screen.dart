import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  static final String id = 'event_screen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.pink,
    );
  }
}

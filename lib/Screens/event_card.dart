import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mission_app/components/sign_in.dart';
import 'package:mission_app/modules/models/event_modals.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String publisher;
  final String location;
  final String description;
  final String phoneNumber;
  final DateTime date;
  final String time;
  final String document;
  final Function onPress;
  final String btnName;
  final Function btnFun;

  EventCard(
      {this.onPress,
      @required this.btnName,
      @required this.btnFun,
      @required this.title,
      @required this.publisher,
      @required this.date,
      @required this.time,
      @required this.location,
      @required this.description,
      @required this.document,
      @required this.phoneNumber});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    Future<void> _makePhoneCall(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    final String formatted = formatter.format(widget.date);

    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 25),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: email == widget.publisher ? Colors.black54 : Colors.white12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${widget.title}',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                flatBtn(
                  widget: widget,
                  btnName: widget.btnName,
                  phoneNumber: widget.phoneNumber,
                  btnFun: widget.btnFun,
                  title: widget.title,
                  description: widget.description,
                  cityName: widget.location,
                  noOfVolunteers: widget.document,
                  document: widget.document,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${widget.publisher}',
              style: TextStyle(
                color: Color(0xffeb1555),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${widget.location} ,'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$formatted',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Text("Event time: " + widget.time)
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              ' ' '  ${widget.description}',
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
                    print(widget.phoneNumber);
                    setState(() {
                      _makePhoneCall('tel: ${widget.phoneNumber}');
                    });
                  },
                  child: Text(
                    '${widget.phoneNumber}',
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
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mission_app/components/sign_in.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String publisher;
  final String location;
  final String description;
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
      @required this.document});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
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
                flatBtn(
                  widget: widget,
                  btnName: widget.btnName,
                  btnFun: widget.btnFun,
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
                        fontSize: 10,
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
          ],
        ),
      ),
    );
  }
}

class flatBtn extends StatelessWidget {
  const flatBtn({
    Key key,
    @required this.widget,
    @required this.btnFun,
    @required this.btnName,
  }) : super(key: key);

  final EventCard widget;
  final Function btnFun;
  final String btnName;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: email == widget.publisher
            ? PopupMenuButton(
                child: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Row(
                        children: [
                          Icon(Icons.edit),
                          Text("Edit"),
                        ],
                      )),
                      PopupMenuItem(
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
                color: Color(0xffeb1555),
                onPressed: btnFun,
                child: Text(btnName),
              ));
  }
}

// () {
// FirebaseFirestore.instance
//     .collection("events")
//     .doc("${widget.document}")
//     .update({
// "interested": FieldValue.arrayUnion([email])
// });
// },

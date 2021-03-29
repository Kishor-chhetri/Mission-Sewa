import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  final String docId;

  NewScreen({Key key, @required this.docId}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .doc(widget.docId)
                .snapshots(),
            // ignore: missing_return
            builder: (context, snapshot) {
              final events = snapshot.data;
              final interestedPeople = events['interested'];
              return ListView.builder(
                  itemCount: interestedPeople.length,
                  itemBuilder: (builder, index) {
                    return Center(
                        child: Card(
                            child: Text(interestedPeople[index].toString())));
                  });
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendEmail extends StatefulWidget {
  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> send() async {
    Widget build(BuildContext context) {
      return new StreamBuilder(
          stream: fireStore.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            final userDocument = snapshot.data.docs;

            return new Text(userDocument["name"]);
          });
    }

    final _recipientController = TextEditingController(
      text: '',
    );

    final _subjectController = TextEditingController(text: 'The subject');

    final _bodyController = TextEditingController(
      text: 'Mail body.',
    );

    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
    Navigator.pop(context);
  }

  final _recipientController = TextEditingController(
    text: '',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                "Send Email",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recipient',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Subject',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Body',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color(0xffeb1555),
                onPressed: () {
                  send();
                },
                child: Text("Send"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

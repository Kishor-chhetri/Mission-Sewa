import 'package:flutter/material.dart';
import 'package:mission_app/modules/models/event_modals.dart';
import '../constants.dart';
import 'event_screen.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 500,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              FirstScreenButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    final user =
                        await auth.sendPasswordResetEmail(email: email);
                    SnackBar(
                      content: Text(
                          "An email has been sent to $email to reset your password"),
                    );
                    Navigator.pop(context);
                  },
                  title: 'Reset'),
            ])),
      ),
    );
  }
}

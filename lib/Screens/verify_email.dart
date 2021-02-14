import 'package:flutter/material.dart';
import 'package:mission_app/constants.dart';

class VerifyEmail extends StatefulWidget {
  static final String id = 'verify_email';

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Image.asset('images/verify.png'),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
          ),
        ],
      ),
    );
  }
}

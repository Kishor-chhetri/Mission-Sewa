import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mission_app/Screens/verify.dart';
import 'package:mission_app/modules/models/event_modals.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import 'event_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  String name;
  String description;
  String phone_number;

  final auth = FirebaseAuth.instance;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Full Name'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
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
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  description = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Tell us about yourself'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  phone_number = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Phone Number'),
              ),
              SizedBox(
                height: 8.0,
              ),
              FirstScreenButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () {
                  auth
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((_) {
                    FirebaseFirestore.instance.collection('users').add({
                      'full_name': name,
                      'email': email,
                      'description': description,
                      'phone_number': phone_number,
                      'uid': auth.currentUser.uid
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyScreen()));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

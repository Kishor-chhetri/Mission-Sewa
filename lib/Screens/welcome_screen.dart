import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'login.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: Container(
              height: 150.0,
              width: 150.0,
              child: Image.asset('images/logo.png'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TypewriterAnimatedTextKit(
            text: ['Mission Sewa'],
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
          RoundedButton(
            title: 'Log In',
            colour: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
          RoundedButton(
            title: 'Register',
            colour: Colors.blueAccent,
            onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
          ),
        ],
      ),
    ));
  }
}

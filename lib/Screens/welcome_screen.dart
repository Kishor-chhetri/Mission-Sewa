import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mission_app/Screens/event_screen.dart';
import 'package:mission_app/components/rounded_button.dart';
import 'package:mission_app/components/sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'event_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
            Hero(
              tag: 'logo',
              child: Container(
                height: 225.0,
                width: 230.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TypewriterAnimatedTextKit(
              text: ['Mission Sewa'],
              repeatForever: true,
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 90),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 25.0, height: 110.0),
                  Text(
                    "For",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  SizedBox(width: 20.0, height: 100.0),
                  RotateAnimatedTextKit(
                      repeatForever: true,
                      text: ["YOUTH", "SOCIETY", "NATION"],
                      textStyle: TextStyle(fontSize: 25.0, color: Colors.green),
                      textAlign: TextAlign.start),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedButton(
              title: 'Sign In With Google',
              colour: Color(0xffeb1555),
              onPressed: () {
                signInWithGoogle().then((result) {
                  if (result != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return EventScreen();
                        },
                      ),
                    );
                  }
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Login to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

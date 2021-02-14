import 'package:flutter/material.dart';
import 'package:mission_app/Screens/event_screen.dart';
import 'package:mission_app/Screens/verify_email.dart';
import 'package:mission_app/Screens/welcome_screen.dart';
import 'package:mission_app/Screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mission_app/Screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        EventScreen.id: (context) => EventScreen(),
        VerifyEmail.id: (context) => VerifyEmail(),
      },
    );
  }
}

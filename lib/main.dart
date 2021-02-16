import 'package:flutter/material.dart';
import 'package:mission_app/Screens/event_screen.dart';
import 'package:mission_app/Screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mission_app/components/add_events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        accentColor: Color(0x11eb1555),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        EventScreen.id: (context) => EventScreen(),
        TaskScreen.id: (context) => TaskScreen(),
      },
    );
  }
}

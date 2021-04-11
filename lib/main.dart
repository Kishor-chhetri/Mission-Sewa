import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mission_app/Screens/event_screen.dart';
import 'package:mission_app/Screens/new_screen.dart';
import 'package:mission_app/Screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mission_app/components/add_events.dart';
import 'package:mission_app/Screens/nearby_events.dart';
import 'package:mission_app/Screens/interested_events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Color(0x11eb1555),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        EventScreen.id: (context) => EventScreen(),
        TaskScreen.id: (context) => TaskScreen(),
        NearbyEvents.id: (context) => NearbyEvents(),
        InterestedEvents.id: (context) => InterestedEvents(
              firestore: _fireStore,
            ),
        NewScreen.id: (context) => NewScreen(
              docId: null,
            ),
      },
    );
  }
}

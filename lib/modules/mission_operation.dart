import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mission_app/modules/models/event_modals.dart';

class MissionOperation {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void deleteEvent(String docId) {
    firestore.collection("events").doc(docId).delete();
  }

  void createEvent(EventModel model) {
    firestore.collection("events").doc().set(model.toJson());
  }

  Stream<EventModel> getEventLocation(String docId) {
    return null;
  }
}

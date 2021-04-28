import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mission_app/Screens/verify.dart';
import 'package:mission_app/modules/models/event_modals.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import 'package:mission_app/components/city_name_list.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  String userRoleType = "Volunteer";
  bool registered = false;
  final auth = FirebaseAuth.instance;
  String organization;
  String previousEvents;
  String imageUrl;
  bool showSpinner = false;
  File imageFile;
  File file;
  UploadTask task;

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String role in userRole) {
      var newItem = DropdownMenuItem(child: Text(role), value: role);
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  void uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    int count = 1;
    image = await _picker.getImage(source: ImageSource.gallery);
    var file = File(image.path);

    if (image != null) {
      var snapshot =
          await _storage.ref().child('citizens/${count}').putFile(file);
      var downloadURL = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadURL;
        count = count + 1;
      });
    } else {
      print('No Path Received');
    }
  }

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
              Container(
                margin: EdgeInsetsDirectional.only(top: 150),
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
              Container(
                child: Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Full Name'),
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
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Your Email'),
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
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Phone Number'),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Who You Are?"),
                              DropdownButton<String>(
                                  value: userRoleType,
                                  items: getDropdownItems(),
                                  onChanged: (value) {
                                    setState(() {
                                      userRoleType = value;
                                    });
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "For Organizers",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "(You must fill all the credentials below if you want to be accepted as an organizer then only you will be able to create events.)",
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              organization = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Associated Organization'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              previousEvents = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Any Events You Organized Before'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          (imageUrl != null)
                              ? Image.network(imageUrl)
                              : Placeholder(
                                  fallbackHeight: 200.0,
                                  fallbackWidth: double.infinity,
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            onPressed: () {
                              print(imageUrl);
                              uploadImage();
                            },
                            child: Text('Upload Image'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FirstScreenButton(
                            color: Colors.blueAccent,
                            title: 'Register',
                            onPressed: () {
                              auth
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((_) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(auth.currentUser.uid)
                                    .set({
                                  'full_name': name,
                                  'email': email,
                                  'description': description,
                                  'phone_number': phone_number,
                                  'uid': auth.currentUser.uid,
                                  'interested_types': [],
                                  'registered': registered,
                                  'role': userRoleType,
                                  'organiztion': organization,
                                  'photo_url': imageUrl,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// uploadImage() async {
//   final _picker = ImagePicker();
//   PickedFile image;
//
//   image = await _picker.getImage(source: ImageSource.gallery);
//   var file = File(image.path);
//
//   var snapshot = await _storage
//       .ref()
//       .child('folderName/ImageName')
//       .putFile(file)
//       .onComplete;
// }

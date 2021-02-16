import 'package:flutter/material.dart';
import 'package:mission_app/components/rounded_button.dart';

class TaskScreen extends StatefulWidget {
  static const String id = "add_events";

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create New Event',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFieldWidget(
                  hintText: 'Title',
                  maxLine: 1,
                ),
                TextFieldWidget(
                  hintText: 'Description',
                  keyType: TextInputType.multiline,
                  maxLine: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("${selectedDate.toLocal()}".split(' ')[0]),
                    RoundedButton(
                      onPressed: () => _selectDate(context),
                      title: 'Select Event Date',
                    ),
                  ],
                ),
                RoundedButton(
                  colour: Color(0xffeb1555),
                  title: 'Create Event',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextInputType keyType;
  final int maxLine;

  TextFieldWidget({@required this.hintText, this.keyType, this.maxLine});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: TextField(
        keyboardType: keyType,
        maxLines: maxLine,
        autofocus: false,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          enabled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffeb1555),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffeb1555),
            ),
          ),
          hintText: hintText,
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class NewScreen extends StatefulWidget {
  static const String id = "new_screen";
  final String docId;

  NewScreen({Key key, @required this.docId}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      return doc.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .doc(widget.docId)
                .snapshots(),
            // ignore: missing_return
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final events = snapshot.data;
              final interestedPeople = events['interested'];
              return Scaffold(
                body: SafeArea(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(shrinkWrap: true, children: [
                        RepaintBoundary(
                          key: _printKey,
                          child: Container(
                              child: Column(
                            children: [
                              Text(
                                "Interested People",
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.none,
                                    color: Colors.white54),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: interestedPeople.length,
                                  itemBuilder: (builder, index) {
                                    return Center(
                                        child: Card(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 17, horizontal: 15),
                                        height: 50,
                                        width: double.infinity,
                                        child: Text(
                                          interestedPeople[index].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ));
                                  }),
                            ],
                          )),
                        ),
                      ]),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.print),
                  onPressed: _printScreen,
                ),
              );
            }));
  }
}

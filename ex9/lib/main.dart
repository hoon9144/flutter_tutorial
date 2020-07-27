import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(home: FirestoreFirstDemo(),));

FirestoreFirstDemoState pageState;

class FirestoreFirstDemo extends StatefulWidget {
  @override
  FirestoreFirstDemoState createState() {
    pageState = FirestoreFirstDemoState();
    return pageState;
  }
}

class FirestoreFirstDemoState extends State<FirestoreFirstDemo> {
  final firestoreInstance =  Firestore .instance;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Chat!")),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 450,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("chat").snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      default:
                        return ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            Timestamp tt = document["datetime"];
                            DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
                                tt.microsecondsSinceEpoch);
                            return Card(
                              elevation: 2,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          document["name"],
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          dt.toString(),
                                          style: TextStyle(color: Colors.grey[600]),
                                        )
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        document["description"],
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
              TextField(
                controller: textEditingController,
                cursorWidth: 1,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: "여기에 입력해주세요!",
                    suffixIcon: IconButton(icon: Icon(Icons.email), onPressed: (){
                    print('hello?');
                    var now = new DateTime.now();
                    print(now);
                    firestoreInstance.collection("chat").add(
                        {
                          "name" : "john",
                          "description" : textEditingController.text,
                          "datetime" : now
                        }).then((value){
                      print(value.documentID);
                    });
                  })
                ),
              )
            ],
          ),
      ),
      );
  }
}
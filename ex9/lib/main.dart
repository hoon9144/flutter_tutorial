import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: FirestoreChat()));
}

class FirestoreChat extends StatelessWidget {
  final firestoreInstance = Firestore.instance;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Firestore Chat!")),
        body: Column(
          children: <Widget>[
            Expanded(child: msgBuild()),
            sendAction(),
          ],
        ));
  }

  Widget msgBuild() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("chat").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
//                  final m = snapshot.data.documents => List<DocumentsSnapshot>
//                  final m = snapshot.data.documents[index] => DocumentSnapshot
//                  final m = snapshot.data.documents[index].data; => Map<String, dynamic>
                  final m = snapshot.data.documents[index].data;
                 Chat  c =  Chat.fromJson(m);
                 Timestamp date_time = c.datetime;
                 var date = date_time.toDate();
                 return MessageWidget(snapshots: c, date: date);
                });
        }
      },
    );
  }

  Widget sendAction() {
    return TextField(
      controller: textEditingController,
      cursorWidth: 1,
      showCursor: true,
      decoration: InputDecoration(
          hintText: "여기에 입력해주세요!",
          suffixIcon: IconButton(
              icon: Icon(Icons.email),
              onPressed: () {
                var now = new DateTime.now();
                firestoreInstance.collection("chat").add({
                  "name": "bing",
                  "message": textEditingController.text,
                  "datetime": now
                });
              })),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key key,
    @required this.snapshots,
    @required this.date,
  }) : super(key: key);

  final Chat snapshots;
  final DateTime date;


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(snapshots.name),
                Spacer(),
                Text('${date}')
              ],
            ),
            SizedBox(height: 10),
            Text('message : ${snapshots.message}')
          ],
        ),
      ),
    );
  }
}

class Chat{
  String name;
  String message;
  Timestamp datetime;

  Chat({this.name , this.message, this.datetime});

  factory Chat.fromJson(Map<String, dynamic> data){
    return Chat(
      name : data['name'],
        message: data['message'],
      datetime: data['datetime']
    );
  }
}


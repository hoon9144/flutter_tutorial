import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String userName = 'JEONGHOON';
  String userPwd = '';
  
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  String changeName(String _name){
    setState(() {
      userName = _name;
      print('changed name => $userName');
    });
  }

   String changePwd(String _pwd){
    setState(() {
      userPwd = _pwd;
      print('changed pwd => $userPwd');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('StateFull'),
      ),body: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: '이름'
            ),
            onChanged: (text){
              changeName(text);
            },
          ), TextField(
            controller: pwdController,
            decoration: InputDecoration(
              hintText: '비밀번호'
            ),
            onChanged: (pwd){
              changePwd(pwd);
            }
          ),RaisedButton(
            child: Text('Tap!'),
            color: Colors.amber,
            onPressed: (){
             scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text("${nameController.text}")));
            },
          )
        ],
      ),
    );
  }
}
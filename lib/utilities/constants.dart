import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


Alert alertGenerator(context, title, alertContent)=>Alert(
  context: context,
  type: AlertType.error,
  title: title,
  desc: alertContent,
  buttons: [
    DialogButton(
      color: Colors.red,
      child: Text(
        "Retry",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(context),
      width: 120,
    )
  ],
);

const colorizeColors = [
  Color(0xFFde21d2),
  Color(0xFFe619a0),
  Color(0xFFe71863),
  Color(0xFFec1334),
  Color(0xFFef2f10),
  Color(0xFFe619a0),
  Color(0xFFde21d2),
];

const colorizeTextStyle = TextStyle(
  fontSize: 18.0,
  fontFamily: 'Pacifico',
);

Widget popUpMenuButtonGenerator(context, _auth)=>PopupMenuButton<String>(
  icon: Icon(Icons.more_vert,color: Color(0xffe1701a),size: 30,),
  onSelected: (value){
    if(value=="Logout"){
      _auth.signOut();
      Navigator.popUntil(context, ModalRoute.withName("/welcome_page"));
    }
    else if(value=="Text New User"){
      Navigator.pop(context);
    }
  },
  itemBuilder: (BuildContext context) {
    return {'Logout', 'Text New User'}.map((String choice) {
      return PopupMenuItem<String>(
        value: choice,
        child: Text(choice),
      );
    }).toList();
  },
);
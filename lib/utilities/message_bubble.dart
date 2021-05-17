import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  MessageBubble({@required this.msgText, @required this.isSenderOrReceiver, @required this.time});

  final String msgText;
  final String isSenderOrReceiver;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: isSenderOrReceiver=="sender" ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children:[
          Material(
            color:  isSenderOrReceiver=="sender" ? Color(0xffe1701a): Color(0xffeeeeee),
            elevation: 5,
            borderRadius: isSenderOrReceiver=="sender" ? BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)): BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("$msgText",
                style: TextStyle(
                  fontSize: 20,
                  color: isSenderOrReceiver=="sender" ? Colors.white :Color(0xffe1701a),
                ),),
            ),
          ),
          Text(time),
        ],
      ),
    );
  }
}
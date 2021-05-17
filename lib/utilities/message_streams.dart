import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MessageStreams extends StatelessWidget {

  MessageStreams({@required this.senderEmail, @required this.receiverEmail,@required this.firestore});

  final String senderEmail;
  final String receiverEmail;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').orderBy("time", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            backgroundColor: Colors.orange.shade800,
          );
        }
        List<MessageBubble>  msgList=[];

        final msgs= snapshot.data.docs;

        for(var msg in msgs)
        {
          if(msg.get("sender")==receiverEmail || msg.get("receiver")==receiverEmail)
          {
            if(msg.get("sender")==senderEmail)
            {
              Timestamp showTime=msg.get("showTime");
              DateTime realTime=DateTime.fromMicrosecondsSinceEpoch(showTime.microsecondsSinceEpoch);
              String timeString="${realTime.hour}:${realTime.minute}";
              msgList.add(MessageBubble(msgText: msg.get("msgContent"), isSenderOrReceiver: "sender", time: timeString,));
            }
            else if(msg.get("receiver")==senderEmail)
            {
              Timestamp showTime=msg.get("showTime");
              DateTime realTime=DateTime.fromMicrosecondsSinceEpoch(showTime.microsecondsSinceEpoch);
              String timeString=" ${realTime.hour}:${realTime.minute}";
              msgList.add(MessageBubble(msgText: msg.get("msgContent"), isSenderOrReceiver: "receiver", time: timeString,));
            }
          }

        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.all(20),
            children: msgList,
          ),
        );
      },
    );
  }
}
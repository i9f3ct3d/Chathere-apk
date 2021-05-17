import 'package:flutter/material.dart';
import 'avatar_image_widget.dart';

class NewCardsofPrevMessages extends StatelessWidget {
  const NewCardsofPrevMessages({
    Key key,
    @required this.addingUserName,
    @required this.message,
    @required this.profileImageUrl
  }) : super(key: key);

  final String addingUserName;
  final message;
  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarImage(profileImageUrl: profileImageUrl,radius: 35,),
          Flexible(
            child: SizedBox(
              width: 30,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addingUserName,
                style: TextStyle(
                  fontFamily: "Monoton",
                  fontSize: 30,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),),
              Text(message.data()["msgContent"].length>=19 ? ":  "+message.data()["msgContent"].substring(0,20)+" ....": ":  "+message.data()["msgContent"],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700
                ),),

            ],),

        ],
      ),
    );
  }
}



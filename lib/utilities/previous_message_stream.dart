import 'package:flutter/material.dart';
import '../pages/search_page.dart';
import '../pages/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/new_cards_of_prev_messages.dart';

FirebaseFirestore _firestore=FirebaseFirestore.instance;



class PreviousMessageStream extends StatefulWidget {

  PreviousMessageStream({@required this.loggedInUserEmail});

  final String loggedInUserEmail;

  @override
  _PreviousMessageStreamState createState() => _PreviousMessageStreamState();
}

class _PreviousMessageStreamState extends State<PreviousMessageStream> {

  QuerySnapshot users;

  getUsers()async{
    users=await _firestore.collection("users").get();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUsers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("messages").orderBy("time", descending: true).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
        {
          return CircularProgressIndicator(
            backgroundColor: Colors.blue,
          );
        }

        List<Widget> prevMessageList=[];
        List<String> checkedInUserNames=[];

        for(var message in snapshot.data.docs)
        {
          bool add=false;
          String type;
          if(message.data()["sender"]==widget.loggedInUserEmail)
          {
            String eachUserName=message.data()["receiver"];
            if(!checkedInUserNames.contains(eachUserName)){
              type="receiver";
              add=true;
              checkedInUserNames.add(eachUserName);
            }
          }
          else if (message.data()["receiver"]==widget.loggedInUserEmail)
          {
            String eachUserName=message.data()["sender"];
            if(!checkedInUserNames.contains(eachUserName)){
              type="sender";
              add=true;
              checkedInUserNames.add(eachUserName);
            }
          }
          if(add)
          {
            String addingEmail=message.data()[type];
            String addingUserName="";
            String addingProfileImageUrl;
            if(users!=null)
              {
                for(var user in users.docs)
                {
                  if(user.get("email")==addingEmail)
                  {
                    addingUserName=user.get("username");
                    addingProfileImageUrl=user.get("profileImageUrl");
                  }
                }
              }

            prevMessageList.add(
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(recEmail: message.data()[type],recUserName: addingUserName,profileImageUrl: addingProfileImageUrl)));
                },
                child: Column(
                  children: [NewCardsofPrevMessages(addingUserName: addingUserName, message: message, profileImageUrl: addingProfileImageUrl),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff8c6a10),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(2,2),
                        )
                      ],
                      color: Colors.orange.shade300,
                    ),
                    height: 3,
                    width: 250,
                  ),
                    SizedBox(
                      height: 15,
                    ),]
                ),
              ),);
          }
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange.shade300,
                ),
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: prevMessageList,
                ),
              ),
            ),
          ),
        );
      },
    );;
  }
}


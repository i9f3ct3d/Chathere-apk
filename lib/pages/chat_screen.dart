

import 'package:chat_here/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utilities/message_streams.dart';
import '../utilities/avatar_image_widget.dart';
import 'dart:math' as math;


FirebaseFirestore _firestore = FirebaseFirestore.instance;
bool runAgain=true;

class ChatScreen extends StatefulWidget {
  ChatScreen({@required this.recEmail,@required this.recUserName, @required this.profileImageUrl});

  final String recEmail;
  final String recUserName;
  final String profileImageUrl;



  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  Animation animation;
  AnimationController animationController;

  FirebaseAuth _auth = FirebaseAuth.instance;

  String newMessage;

  String senderEmail;

  String receiverEmail;

  final textFieldController = TextEditingController();

  bool isDisabledSendButton=true;

  @override
  void initState() {
    // TODO: implement initState
    getSender();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(animationController!=null)
      animationController.dispose();
    super.dispose();
  }

  void getSender() {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        senderEmail = user.email;
        receiverEmail=widget.recEmail;
      }
    } catch (e) {
      print(e);
    }
  }

  void controlAnimation(){
    animationController=AnimationController(
      duration: Duration(milliseconds: 500),
      upperBound: 360,
      lowerBound: 180,
      vsync: this,
    );


    animationController.reverse(from: 360);
    animationController.addListener(() {
      print(runAgain);
      print(animationController.value);
        if(animationController.value==180 && runAgain)
          {

            runAgain=false;
            animationController.forward(from: 180);
          }
        setState(() {

        });
    });
  }

  void controlOnchange(value){
    newMessage = value;
    if(newMessage==null || newMessage.trim().length==0)
    {
      print("true");
      isDisabledSendButton=true;
    }
    else isDisabledSendButton=false;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());//when clicked outside of textField keyboard goes out of focus or closes
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Color(0xffe1701a),
          ),
          backgroundColor: Color(0xfff7a440),
          title: Row(
            children: [
              AvatarImage(profileImageUrl: widget.profileImageUrl, radius: 20),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(widget.recUserName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe1701a),
                      fontFamily: "Pacifico",
                      letterSpacing: 2,
                  ),),
                ),),
            ],
          ),
          actions: <Widget>[
            popUpMenuButtonGenerator(context, _auth),
          ],
        ),
        body: Container(
          color: Color(0xfff6dcbf),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MessageStreams(senderEmail: senderEmail, receiverEmail: receiverEmail, firestore: _firestore,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Theme(
                        data: ThemeData().copyWith(
                          primaryColor: Color(0xffe1701a),
                        ),
                        child: TextField(
                          controller: textFieldController,
                          maxLines: newMessage!=null && newMessage.length>=132?4:null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(

                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              hintText: "type message",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onChanged: (value) {
                            setState(() {
                              controlOnchange(value);
                            });

                          },
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      if(newMessage!=null && newMessage.trim().length>0)
                        {
                          runAgain=true;
                          controlAnimation();

                          _firestore.collection("messages").add({
                            "msgContent": newMessage,
                            "sender": senderEmail,
                            "receiver": widget.recEmail,
                            "time": DateTime.now().millisecondsSinceEpoch,
                            "showTime" :DateTime.now(),
                          });


                        }
                      newMessage=null;
                      textFieldController.clear();
                      await new Future.delayed(const Duration(milliseconds: 1000));
                      setState(() {
                        isDisabledSendButton=true;
                      });

                    },
                    child: Transform.rotate(
                      angle: (animationController!=null ? animationController.value: 360) * math.pi / 180,
                      child: Icon(
                        Icons.send_outlined,
                        color: isDisabledSendButton?Colors.grey:Color(0xfff7a440),
                        size: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}











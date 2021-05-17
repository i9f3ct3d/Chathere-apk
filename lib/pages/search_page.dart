import 'package:chat_here/utilities/avatar_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utilities/previous_message_stream.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  String searchUserName;
  bool haveUserSearched = false;
  bool showSpinner = false;
  String loggedInUserEmail;
  String loggedInUserName;
  String loggedInUserProfileImageUrl;

  QuerySnapshot searchResultSnapshot;

  var previousMessages;

  final List<DropdownMenuItem> items = [];

  getMessages() async {
    setState(() {
      showSpinner = true;
    });

    previousMessages = await _firestore
        .collection("messages")
        .orderBy("time", descending: true)
        .get();
    setState(() {
      showSpinner = false;
    });
  }

  initiateSearch() async {
    setState(() {
      showSpinner = true;
    });
    searchResultSnapshot = await _firestore.collection("users").get();
    userList();
    setState(() {
      haveUserSearched = true;
      showSpinner = false;
    });
  }

  void userList() //generate userList for dropdown user search listView
  {
    for (var user in searchResultSnapshot.docs) {
      if(user.get("email")!=loggedInUserEmail)
        {
          items.add(DropdownMenuItem(
            child: TextButton(
              child: Row(
                children: [
                  Flexible(
                    child: AvatarImage(
                      radius: 25,
                      profileImageUrl: user.get("profileImageUrl"),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                  Text(
                    user.get("username"),
                    style: TextStyle(
                      color: Colors.orange,
                      fontFamily: "Pacifico",
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          recEmail: user.get("email"),
                          recUserName: user.get("username"),
                          profileImageUrl: user.get("profileImageUrl") != null
                              ? user.get("profileImageUrl")
                              : null,
                        )));
                getMessages();
              },
            ),
            value: user.get("username"),
          ));
        }
    }
  }

  callInitiateSearch() async {
    items.clear();
    await initiateSearch();
    setState(() {
      showSpinner = false;
    });
  }

  void getUserName() async {
    setState(() {
      showSpinner = true;
    });
    QuerySnapshot users = await _firestore
        .collection("users")
        .where("email", isEqualTo: loggedInUserEmail)
        .get();
    loggedInUserName = users.docs[0].get("username");
    loggedInUserProfileImageUrl = users.docs[0].get("profileImageUrl");
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initiateSearch();
    loggedInUserEmail = _auth.currentUser.email;
    getMessages();
    getUserName();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title:  Text('Are you sure?'),
        content:  Text('Do you want to log Out'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text('No',style: TextStyle(color: Colors.blue,fontSize: 20)),
          ),
          TextButton(
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pop(true);
              },
            child:  Text('Yes',style: TextStyle(color: Colors.red,fontSize: 20),),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var selectedValue;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add your onPressed code here!
                  setState(() {
                    showSpinner = true;
                    callInitiateSearch();
                    getMessages();
                  });
                },
                child: const Icon(Icons.update),
                backgroundColor: Colors.orange,
              ),
              body: SlidingUpPanel(
                collapsed: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color(0xfff6dcbf),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Monoton',
                                color: Colors.redAccent),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                RotateAnimatedText('WELCOME'),
                                RotateAnimatedText(loggedInUserName != null ? loggedInUserName : ""),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                minHeight: 100,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                panel: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(0xffffc288),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      AvatarImage(
                          profileImageUrl: loggedInUserProfileImageUrl,
                          radius: 100),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: Text(
                                "Username : ",
                                style: TextStyle(
                                  fontFamily: "Monoton",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                loggedInUserName == null ? "" : loggedInUserName,
                                style: TextStyle(
                                  fontFamily: "Pacifico",
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: Text(
                                "Email : ",
                                style: TextStyle(
                                  fontFamily: "Monoton",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                loggedInUserEmail == null ? "" : loggedInUserEmail,
                                style: TextStyle(
                                  fontFamily: "Pacifico",
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                body: Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      gradient: LinearGradient(colors: [
                    Colors.orange.shade200,
                    Colors.orange.shade500
                  ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xfff6dcbf),
                            ),
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Colors.orange
                              ),
                              child: SearchableDropdown.single(
                                displayClearIcon: false,
                                menuBackgroundColor: Color(0xfff6dcbf),
                                iconEnabledColor: Colors.orange,
                                iconSize: 35,
                                style: TextStyle(
                                  fontFamily: "Pacifico",
                                  fontSize: 20,
                                ),
                                icon: Icon(Icons.search),
                                items: items,
                                value: selectedValue,
                                hint: "Search ...",
                                // searchHint: "username",
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                isExpanded: true,
                                clearIcon: Icon(
                                  Icons.clear,
                                  color: Color(0xfff6dcbf),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      PreviousMessageStream(loggedInUserEmail: loggedInUserEmail),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

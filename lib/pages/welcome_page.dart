import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffffb26b),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(
                FontAwesomeIcons.replyAll,
                color: Color(0xffe1701a),
                size: 50,
              ),
              Flexible(
                child: SizedBox(
                  width: 30,
                ),
              ),
              Text("ChatHere",
              style: TextStyle(
                color: Color(0xffe1701a),
                fontFamily: "Monoton",
                fontSize: 30
              ),)
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          color: Color(0xfff6dcbf),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Material(
                  borderRadius: BorderRadius.circular(150),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                        border: Border.all(color: Colors.black12)
                    ),
                    child: CircleAvatar(
                      radius: 150,
                      backgroundImage: AssetImage("assets/images/chat.jpg"),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Connect Together",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(4.0, 4.0),
                        blurRadius: 8.0,
                        color: Colors.grey,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(60, 10, 60, 0),
                child: Text(
                  "In the tumultuous business of cutting-in and attending to a whale, there is",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
                child: Material(
                  elevation: 5,
                  color: Color(0xffe1701a),
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/registration_page");
                    },
                    child: Container(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 60,vertical: 20),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login_page");
                  },
                  child: Text("Log In",
                  style: TextStyle(
                    color: Color(0xffe1701a),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 20,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

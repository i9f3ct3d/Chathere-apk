import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../utilities/constants.dart';
import 'package:email_validator/email_validator.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> with SingleTickerProviderStateMixin{


  AnimationController animationController;
  Animation animation;

  FirebaseAuth _auth=FirebaseAuth.instance;

  String email;
  String password;
  bool showSpinner=false;

  double elevationEmailField=0;
  double elevationPasswordField=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController=AnimationController(
      duration: Duration( seconds: 2),
      vsync: this,
    );

    animation=ColorTween(begin: Color(0xffe1701a), end: Color(0xfff6dcbf)).animate(animationController);

    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();//destroys animation after quitting app or destroying current class
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Theme(
        data: ThemeData(
          primaryColor: Color(0xffe1701a),
        ),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());//when clicked outside of textField keyboard goes out of focus or closes
          },
          child: Scaffold(
            backgroundColor: animation.value,
            body: SafeArea(
              child: ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    FontAwesomeIcons.replyAll,
                    color: Color(0xffe1701a),
                    size: MediaQuery.of(context).viewInsets.bottom==0? animationController.value*100: null,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        WavyAnimatedText(
                          'Chat Here',
                          textAlign: TextAlign.left,
                          textStyle: TextStyle(
                            color: Color(0xfff7a440),
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Pacifico",
                          ),
                        ),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Material(
                      color: Color(0xfff6dcbf),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      elevation: elevationEmailField,
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (value){
                            setState(() {
                              value?elevationEmailField=10:elevationEmailField=0;
                            });
                          },
                          child: TextField(
                            onChanged: (value){
                              email=value;
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Email here",
                              labelText: "Email",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Material(
                      color: Color(0xfff6dcbf),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      elevation: elevationPasswordField,
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (value)
                          {
                            setState(() {
                              value?elevationPasswordField=10:elevationPasswordField=0;
                            });
                          },
                          child: TextField(
                            onChanged: (value){
                              password=value;
                            },
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Password here",
                                labelText: "Password",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Color(0xffe1701a)
                        )
                      ),
                      elevation: 5,
                      color: Colors.white,
                      child: MaterialButton(
                        onPressed: () async{
                          email=email.trim();
                          try{
                            if(email!=null && password!= null)
                              {
                                setState(() {
                                  showSpinner=true;
                                });
                                if(EmailValidator.validate(email)){
                                  var user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                                  if(user!=null)
                                  {
                                    Navigator.pushNamed(context, "/test_page");
                                  }else{
                                    alertGenerator(context, "SignIn Failed", "Sign in failed for unknown reason").show();
                                  }
                                }else{
                                  //invalid format of email
                                  alertGenerator(context, "Invalid Email Format", "Please Enter correct format of email").show();
                                }

                              }
                            else{
                              alertGenerator(context, "ERROR OCCURRED", "All the fields are necessary").show();
                            }
                          }on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              alertGenerator(context, "INVALID EMAIL", "Please enter a valid email address").show();

                            } else if (e.code == 'wrong-password') {

                              alertGenerator(context, "WRONG PASSWORD", "Please enter correct password").show();
                            }
                          }
                          catch(e)
                          {
                            alertGenerator(context, "UNKNOWN ERROR OCCURRED", "Error unknown, Sorry for inconvenience").show();
                          }
                          setState(() {
                            showSpinner=false;
                          });
                        },
                        child: Container(
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Color(0xffe1701a),
                              fontSize: 15,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 60),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not Registered Yet ? ",
                        style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 1.5,
                          fontSize: 15,
                        ),),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/registration_page");
                          },
                          child: Text("Register",
                            style: TextStyle(
                              color: Color(0xffe1701a),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 15,
                            ),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}






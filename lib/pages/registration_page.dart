import 'dart:io' as io;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import '../utilities/constants.dart';
import '../utilities/profile_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation animation;

  io.File _userProfileImage;

  void pickProfileImageFunction(io.File image){
    _userProfileImage=image;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation = ColorTween(begin: Colors.orange, end: Color(0xfff6dcbf))
        .animate(animationController);

    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController//destroys animation after quitting app or destroying current class
        .dispose();
    super.dispose();

  }

  bool showSpinner = false;

  String username;
  String email;
  String password;

  double usernameFieldElevation=0;
  double emailFieldElevation=0;
  double passwordFieldElevation=0;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firestorage= FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());//when clicked outside of textField keyboard goes out of focus or closes
        },
        child: Scaffold(
          backgroundColor: animation.value,
          body: SafeArea(
            child: Theme(
              data: ThemeData().copyWith(
                primaryColor: Color(0xffe1701a),
              ),
              child: ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Transform.rotate(
                    angle: 360*animationController.value*math.pi/180,
                    child: Icon(
                      FontAwesomeIcons.replyAll,
                      color: Color(0xffe1701a),
                      size: MediaQuery.of(context).viewInsets.bottom == 0//check if keyboard is open or not
                          ? animationController.value * 100
                          : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        WavyAnimatedText(
                          'Chathere',
                          textAlign: TextAlign.left,
                          textStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Pacifico",
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  ),
                  ProfileImagePicker(pickImageFunction: pickProfileImageFunction),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30,10,30,0),
                    child: Theme(
                      data: ThemeData().copyWith(
                        primaryColor:Color(0xffe1701a),
                      ),
                      child: Material(
                        color: animation.value,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        elevation: usernameFieldElevation,
                        child: FocusScope(
                          child: Focus(
                            onFocusChange: (value){
                              setState(() {
                                value?usernameFieldElevation=10:usernameFieldElevation=0;
                              });
                            },
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });

                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Username here",
                                labelText: "Username",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("*username must be 4 to 8 characters long",
                    style: TextStyle(
                      color: username!=null&& username.length>0 && (username.length>8 || username.length<4) ?Colors.red: Colors.grey.shade600,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Material(
                      color: animation.value,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      elevation: emailFieldElevation,
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (value){
                            setState(() {
                              value?emailFieldElevation=10:emailFieldElevation=0;
                            });
                          },
                          child: TextField(
                            onChanged: (value) {
                              email = value.toLowerCase();
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
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
                      color: animation.value,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      elevation: passwordFieldElevation,
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (value){
                            setState(() {
                              value?passwordFieldElevation=10:passwordFieldElevation=0;
                            });
                          },
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password here",
                              labelText: "Password",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("*password length must be at least 6",
                      style: TextStyle(
                        color: password!=null&& password.length<6 &&password.length>0 ?Colors.red: Colors.grey.shade600,
                      ),),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 0),
                    child: Material(
                      elevation: 5,
                      color: Color(0xffe1701a),
                      borderRadius: BorderRadius.circular(30),
                      child: MaterialButton(
                        onPressed: () async {
                          username=username.trim();
                          email=email.trim();
                          try {
                            if (username != null && email!=null && password!=null && _userProfileImage!=null) {
                              if(username.length<4 || username.length>8)
                                {
                                  alertGenerator(context, "Invalid Username", "Username must be 4 to 8 characters long").show();
                                  return;
                                }
                              setState(() {
                                showSpinner = true;
                              });
                              var users = await _firestore
                                  .collection("users")
                                  .where("username", isEqualTo: username)
                                  .get();
                              if (users.docs.length == 0) {
                                if(EmailValidator.validate(email))
                                  {
                                    var user = await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);

                                    final ref=_firestorage.ref().child("userImage").child(user.user.uid+".jpg");

                                     await ref.putFile(_userProfileImage);

                                     final url=await ref.getDownloadURL();

                                    await _firestore.collection("users").add({
                                      "email": email,
                                      "username": username,
                                      "profileImageUrl": url
                                    });
                                    Navigator.pushNamed(
                                        context, "/test_page");
                                  }else{
                                  //not a valid email
                                  alertGenerator(context, "Invalid Email", "Please enter a correct format of email").show();
                                }
                              }
                              else{
                                //when username already exist
                                alertGenerator(context, "INVALID USERNAME", "Username already in use").show();
                              }
                            }
                            else{
                              //no username
                              alertGenerator(context, "INVALID DATA", "All the fields are necessary").show();
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              alertGenerator(context, "WEAK PASSWORD", "Given Password is too weak....Password length should be at least 6").show();
                            } else if (e.code == 'email-already-in-use') {
                              alertGenerator(context, "INVALID EMAIL", "Email already in use").show();
                            }
                            else if(e.code=='canceled')
                              {
                                alertGenerator(context, "FAILED", "Image upload failed please try again later");
                              }
                          } catch (e) {
                            print(e);
                            alertGenerator(context, "UNKNOWN ERROR OCCURRED", "Error unknown, Sorry for inconvenience").show();
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        },
                        child: Container(
                          // width: 60,
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          // padding: EdgeInsets.symmetric(horizontal: 60),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already Registered ? ",
                        style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 1.5,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/login_page");
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Color(0xffe1701a),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 15,
                            ),
                          ),
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

import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'pages/registration_page.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/search_page.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Firebase.initializeApp();
    return MaterialApp(
      title: 'Chat Here',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/welcome_page",
      routes: {
        "/welcome_page": (context)=>WelcomePage(),
        "/registration_page": (context)=>RegistrationPage(),
        "/login_page": (context)=>LogInPage(),
        "/test_page":(context)=>NewPage(),
      },
    );
  }
}

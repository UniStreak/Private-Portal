import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page_pupil.dart';
import 'sign_up_page.dart';
import 'home_page_tutor.dart';
import 'forum_page.dart';
import 'private_page.dart';
import 'profile_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    SignUpPage.tag: (context) => SignUpPage(),
    HomePageT.tag: (context) => HomePageT(),
    ForumPage.tag: (context) => ForumPage(),
    PrivatePage.tag: (context) => PrivatePage(),
    ProfilePage.tag: (context) => ProfilePage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
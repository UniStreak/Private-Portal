import 'package:flutter/material.dart';
import 'home_page_pupil.dart';
import 'sign_up_page.dart';
import 'home_page_tutor.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String dbType;
  String dbPassword;
  String dbName;
  String dbLogo;
  String dbSchool;
  String dbDesc;
  StreamSubscription<DocumentSnapshot> subscription;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 75.0,
        child: Image.asset('assets/login.png'),
      );

    final appLabel = Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        'Private Portal',
        style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 45.0),
        textAlign: TextAlign.center
      )
    );

    final emailBox = Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 4, 0),
      child: ListTile(
        leading: const Icon(Icons.alternate_email),
        title: new TextFormField(
          controller: emailController,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          decoration: new InputDecoration(
            hintText: "Email",
          ),
        ),
      ),
    );

    final passwordBox = Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
      child: ListTile(
        leading: const Icon(Icons.lock_outline),
        title: new TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: new InputDecoration(
            hintText: "Password",
          ),
        ),
      ),
    );

    final buttons = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        new RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            print("${emailController.text} ${passwordController.text}");
            var id = emailController.text;
            var newID = emailController.text == "" ? "blank" : id;
            Firestore.instance.document("Users/" + newID).get().then((datasnapshot) {
              if (datasnapshot.exists) {
                setState(() {
                  dbPassword = datasnapshot.data['password'];
                  dbType = datasnapshot.data['type'];
                  dbName = datasnapshot.data['name'];
                  dbLogo = datasnapshot.data['logo'];
                  dbSchool = datasnapshot.data['school'];
                  dbDesc = datasnapshot.data['desc'];
                }
                );
                if (passwordController.text == dbPassword ) {
                  if (dbType == "1") {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePageT(uName: dbName, uEmail: emailController.text, uLogo: dbLogo == "" ? "blank" : dbLogo, uSchool: dbSchool, uDesc: dbDesc)
                  ));
                  }
                  else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: new Text("You are not a tutor!"),
                              actions: <Widget>[
                                new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: new Text("Go back"))
                              ]
                          );
                        }
                    );
                  }
                }
                else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: new Text("Incorrect password!"),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("Go back"))
                            ]
                        );
                      }
                  );
                }
              }
              else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: new Text("Incorrect email!"),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: new Text("Go back"))
                          ]
                      );
                    }
                );
              }
            });
          },
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          color: Colors.blueGrey,
          child: Text('Login as tutor', style: TextStyle(
              color: Colors.white,
              fontSize: 17)),
        ),
        new RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            print("${emailController.text} ${passwordController.text}");
            var id = emailController.text;
            var newID = emailController.text == "" ? "blank" : id;
            Firestore.instance.document("Users/" + newID).get().then((datasnapshot) {
              if (datasnapshot.exists) {
                setState(() {
                  dbPassword = datasnapshot.data['password'];
                  dbName = datasnapshot.data['name'];
                  dbLogo = datasnapshot.data['logo'];
                }
                );
                if (passwordController.text == dbPassword) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HomePage(uName: dbName, uEmail: emailController.text, uLogo: dbLogo == "" ? "blank" : dbLogo)
                  )
                  );
                }
                else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: new Text("Incorrect password!"),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("Go back"))
                            ]
                        );
                      }
                  );
                }
              }
              else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: new Text("Incorrect email!"),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: new Text("Go back"))
                          ]
                      );
                    }
                );
              }
            });
          },
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          color: Colors.green[600],
          child: Text('Login as pupil', style: TextStyle(
              color: Colors.white,
              fontSize: 17)),
        )
      ],
    );

    final signUpButton = FlatButton(
      child: Text(
        'Create an account',
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(SignUpPage.tag);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10, top: 90),
          children: <Widget>[
            logo,
            appLabel,
            emailBox,
            passwordBox,
            buttons,
            signUpButton
          ],
        ),
      ),
    );
  }
}


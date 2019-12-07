import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class SignUpPage extends StatefulWidget {
  static String tag = 'sign-up-page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _radioValue1 = -1;
  String userPic;
  StreamSubscription<DocumentSnapshot> subscription;
  FirebaseStorage _storage = FirebaseStorage.instance;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  Future<String> uploadPic() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference reference = _storage.ref().child(emailController.text);
    StorageUploadTask uploadTask = reference.putFile(image);
    String dURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    userPic = dURL;
    print(userPic);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: new Text("Profile photo added successfully."),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("OK!"))
              ]
          );
        }
    );
    return dURL;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final schoolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50,
        child: Image.asset('assets/login.png'),
      );

    final appLabel = Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
            'Private Portal Sign-Up',
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 30),
            textAlign: TextAlign.center
        )
    );

    final nameBox = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        leading: const Icon(Icons.assignment_ind),
        title: new TextFormField(
          controller: nameController,
          maxLines: 1,
          decoration: new InputDecoration(
            hintText: "Name Surname",
          ),
        ),
      ),
    );

    final phoneBox = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        leading: const Icon(Icons.phone_iphone),
        title: new TextFormField(
          controller: phoneController,
          maxLines: 1,
          keyboardType: TextInputType.phone,
          decoration: new InputDecoration(
            hintText: "Phone Number",
          ),
        ),
      ),
    );

    final schoolBox = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        leading: const Icon(Icons.school),
        title: new TextFormField(
          controller: schoolController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            hintText: "Graduated School",
          ),
        ),
      ),
    );

    final emailBox = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          print("${emailController.text} ${passwordController.text} ${nameController.text} ${phoneController.text} ${schoolController.text}");
          if (emailController.text == "" ||
              passwordController.text == "" ||
              nameController.text == "" ||
              schoolController.text == "" ||
              phoneController.text == "" ||
              _radioValue1 == -1){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: new Text("Please complete all forms."),
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
          } else {
            var id=emailController.text;
            Map<String, String> data = <String, String>{
              "name": nameController.text,
              "email": id,
              "password": passwordController.text,
              "phone":  phoneController.text,
              "school": schoolController.text,
              "type": _radioValue1.toString(),
              "logo": userPic,
              "desc": " "
            };
            Firestore.instance.document("Users/" + id).setData(data).whenComplete(() {
              print("Document Added");
            }).catchError((e) => print(e));
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: new Text("Your account successfully created."),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(LoginPage.tag);
                            },
                            child: new Text("Great!"))
                      ]
                  );
                }
            );
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[600],
        child: Text('Create an account', style: TextStyle(
            color: Colors.white,
            fontSize: 17)),
      ),
    );

    final backButton = FlatButton(
      child: Text(
        'Back to login screen',
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(LoginPage.tag);
      },
    );

    final uploadPicButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child:RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          if (emailController.text == ""){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: new Text("To add a profile photo, you have to write your e-mail."),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: new Text("OK!"))
                      ]
                  );
                }
            );
          } else {
            uploadPic();
          }

        },
        padding: EdgeInsets.all(12),
        color: Colors.green[700],
        child: Text(
            'Upload Profile Photo',
          style: TextStyle(color: Colors.white,
          fontSize: 17),
        ),
    ));

    final typeRadio = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: 0,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Pupil',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Padding(padding: new EdgeInsets.symmetric(vertical: 0, horizontal: 25)),
        new Radio(
          value: 1,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Tutor',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            new Padding(padding: new EdgeInsets.symmetric(vertical: 15, horizontal: 0)),
            logo,
            appLabel,
            typeRadio,
            nameBox,
            phoneBox,
            schoolBox,
            emailBox,
            passwordBox,
            uploadPicButton,
            signUpButton,
            backButton
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'forum_page.dart';

class HomePageT extends StatefulWidget {
  static String tag = 'home-page-tutor';
  final String uName;
  final String uEmail;
  final String uLogo;
  final String uSchool;
  final String uDesc;
  HomePageT({Key key, @required this.uName, @required this.uEmail, @required this.uLogo, @required this.uSchool, @required this.uDesc}) : super(key: key);
  @override
  _HomePageStateT createState() => _HomePageStateT(uName,uEmail,uLogo,uSchool,uDesc);
}

class _HomePageStateT extends State<HomePageT> {
  String uName="";
  String uEmail="";
  String uLogo="";
  String uSchool="";
  String uDesc="";
  String firebaseDefaultUserPic = 'https://firebasestorage.googleapis.com/v0/b/privateportal-bb133.appspot.com/o/user.png?alt=media&token=d9b5239a-cd7a-4a44-a9f1-7192a97d6ce2';
  _HomePageStateT(this.uName,this.uEmail, this.uLogo, this.uSchool, this.uDesc);
  StreamSubscription<DocumentSnapshot> subscription;
  final tutorNameController = TextEditingController();
  final tutorMailController = TextEditingController();
  final tutorSchoolController = TextEditingController();
  final tutorDescController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    var id=tutorMailController.text;
    Map<String, String> data = <String, String>{
      "desc": tutorDescController.text,
    };
    Firestore.instance.document("Users/" + id).updateData(data);

    tutorNameController.dispose();
    tutorMailController.dispose();
    tutorSchoolController.dispose();
    tutorDescController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tutorNameController.text = uName;
    tutorMailController.text = uEmail;
    tutorSchoolController.text = uSchool;
    tutorDescController.text = uDesc;
  }

  @override
  Widget build(BuildContext context) {

    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 75.0,
      backgroundImage: uLogo == "blank" ? NetworkImage(firebaseDefaultUserPic): NetworkImage(uLogo),
    );

    final tutorNameText = ListTile(
        leading: const Icon(Icons.assignment_ind),
        title: new TextFormField(
          enabled: false,
          controller: tutorNameController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            labelText: "Name Surname",
          ),
        ),
      );

    final tutorMailText = ListTile(
        leading: const Icon(Icons.alternate_email),
        title: new TextFormField(
          enabled: false,
          controller: tutorMailController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            labelText: "Email",
          ),
        ),
      );

    final tutorSchoolText = ListTile(
        leading: const Icon(Icons.school),
        title: new TextFormField(
          enabled: false,
          controller: tutorSchoolController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            labelText: "Graduated School",
          ),
        ),
      );

    final tutorDescText = ListTile(
        leading: const Icon(Icons.description),
        title: new TextField(
          enabled: true,
          controller: tutorDescController,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: new InputDecoration(
            labelText: "Description",
          ),
        ),
      );


    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          new Card(
            child: new Container(
              padding: new EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: new Column(
                children: <Widget>[
                  logo,
                  tutorNameText,
                  tutorMailText,
                  tutorSchoolText,
                  tutorDescText
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Private Portal", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueGrey,
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.forum),
              tooltip: 'Open forum page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ForumPage(uName: widget.uName, uEmail: widget.uEmail, uLogo: widget.uLogo)
                ));
              })
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Tutor " + widget.uName),
              accountEmail: Text(widget.uEmail),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: uLogo == "blank" ? NetworkImage(firebaseDefaultUserPic): NetworkImage(uLogo),
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}

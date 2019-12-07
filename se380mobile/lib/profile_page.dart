import 'package:flutter/material.dart';
import 'private_page.dart';

class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';
  final String uName;
  final String uName0;
  final String uEmail0;
  final String uEmail;
  final String uLogo0;
  final String uLogo;
  final String uSchool;
  final String uDesc;
  ProfilePage({Key key, @required this.uEmail0, @required this.uName0, @required this.uLogo0,
    @required this.uName, @required this.uEmail, @required this.uLogo, @required this.uSchool, @required this.uDesc}) : super(key: key);
  @override
  _ProfilePageState createState() => new _ProfilePageState(uEmail0, uName0, uLogo0, uName, uEmail, uLogo, uSchool,uDesc);
}

class _ProfilePageState extends State<ProfilePage> {
  String uName="";
  String uName0="";
  String uEmail0="";
  String uEmail="";
  String uLogo0="";
  String uLogo="";
  String uSchool="";
  String uDesc="";
  String firebaseDefaultUserPic = 'https://firebasestorage.googleapis.com/v0/b/privateportal-bb133.appspot.com/o/user.png?alt=media&token=d9b5239a-cd7a-4a44-a9f1-7192a97d6ce2';
  _ProfilePageState(this.uEmail0, this.uName0, this.uLogo0, this.uName,this.uEmail,this.uLogo,this.uSchool,this.uDesc);
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final logo = CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 75.0,
        backgroundImage: uLogo == "blank" ? NetworkImage(firebaseDefaultUserPic): NetworkImage(uLogo),
      );

    final tutorNameText = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        uName,
        style: TextStyle(fontSize: 28.0, color: Colors.blueGrey[700],),
        textAlign: TextAlign.center,
      ),
    );

    final tutorMailText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        uEmail,
        style: TextStyle(fontSize: 20, color: Colors.blueGrey[700],),
        textAlign: TextAlign.center,
      ),
    );

    final tutorSchoolText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        uSchool,
        style: TextStyle(fontSize: 20, color: Colors.blueGrey[700],),
        textAlign: TextAlign.center,
      ),
    );

    final tutorDescText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        uDesc,
        style: TextStyle(fontSize: 15, color: Colors.blueGrey[700],),
        textAlign: TextAlign.center,
      ),
    );

    final msgButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child:RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => PrivatePage(uEmail: uEmail0, uEmail2: uEmail, uLogo: uLogo0 == "" ? "blank" : uLogo0, uName: uName0)));
          },
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          color: Colors.green[600],
          child: Text('Send Message',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17)),
    ));


    return new Scaffold(
        appBar: new AppBar(
          title: new Text(uName+"'s Page", style: TextStyle(color: Colors.white),),
        ),
        body: Container(
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
                      tutorDescText,
                      msgButton
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}




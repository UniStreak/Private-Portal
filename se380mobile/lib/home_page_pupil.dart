import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'forum_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page-pupil';
  final String uName;
  final String uEmail;
  final String uLogo;
  HomePage({Key key, @required this.uName, @required this.uEmail, @required this.uLogo}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(uName,uEmail,uLogo);
}

class _HomePageState extends State<HomePage> {
  String uName;
  String uEmail;
  String uLogo;
  String tutorEmail0 ="";
  String tutorEmail1 ="";
  String tutorEmail2 ="";
  String tutorName0 = "";
  String tutorName1 = "";
  String tutorName2 = "";
  String tutorLogo0 = "";
  String tutorLogo1 = "";
  String tutorLogo2 = "";
  String tutorSchool0 = "";
  String tutorSchool1 = "";
  String tutorSchool2 = "";
  String tutorDesc0 ="";
  String tutorDesc1 ="";
  String tutorDesc2 ="";
  String desc ="";
  String homeText = 'Welcome the Private Portal';
  String logo = 'assets/login.png';
  String firebaseDefaultUserPic = 'https://firebasestorage.googleapis.com/v0/b/privateportal-bb133.appspot.com/o/user.png?alt=media&token=d9b5239a-cd7a-4a44-a9f1-7192a97d6ce2';
  bool itemSelected = false;
  StreamSubscription<DocumentSnapshot> subscription;
  _HomePageState(this.uName,this.uEmail,this.uLogo);
  @override
  Widget build(BuildContext context) {

    Future<void>clickCourse(String cID) async{
      await Firestore.instance.document("Courses/" + cID).get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            homeText = datasnapshot.data['name'];
            desc = datasnapshot.data['desc'];
            tutorEmail0 = datasnapshot.data['tutorNames'][0];
            tutorEmail1 = datasnapshot.data['tutorNames'][1];
            tutorEmail2 = datasnapshot.data['tutorNames'][2];
            logo = datasnapshot.data['logo'];
            itemSelected = true;
          });
        }
      });
      await Firestore.instance.document("Users/" + tutorEmail0).get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            tutorName0 = datasnapshot.data['name'];
            tutorLogo0 = datasnapshot.data['logo'];
            tutorSchool0 = datasnapshot.data['school'];
            tutorDesc0 = datasnapshot.data['desc'];
          });
        }
      });
      await Firestore.instance.document("Users/" + tutorEmail1).get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            tutorName1 = datasnapshot.data['name'];
            tutorLogo1 = datasnapshot.data['logo'];
            tutorSchool1 = datasnapshot.data['school'];
            tutorDesc1 = datasnapshot.data['desc'];
          });
        }
      });
      await Firestore.instance.document("Users/" + tutorEmail2).get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            tutorName2 = datasnapshot.data['name'];
            tutorLogo2 = datasnapshot.data['logo'];
            tutorSchool2 = datasnapshot.data['school'];
            tutorDesc2 = datasnapshot.data['desc'];
          });
        }
      });
    }

    final mainScreenText = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        homeText,
        style: TextStyle(fontSize: 28.0, color: Colors.blueGrey[700],),
        textAlign: TextAlign.center,
      ),
    );

    final descText = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: itemSelected == true ? Text(
        desc,
        style: TextStyle(fontSize: 20.0, color: Colors.blueGrey[700]),
      ) : Text(
        "Please select a course category from the menu.",
        style: TextStyle(fontSize: 15, color: Colors.blueGrey[700]),
      )
    );

    final mainScreenImg = CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 75.0,
        child: itemSelected == true ? Image.network(logo) : Image.asset(logo),
    );

    final tutorList = ExpansionTile(
      title: Text("Tutors"),
      trailing: Icon(Icons.supervisor_account),
      children: <Widget>[
        ListTile(
            title: Text(tutorEmail0),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProfilePage(uEmail0: uEmail, uName0: uName, uLogo0: uLogo, uName: tutorName0, uEmail: tutorEmail0, uLogo: tutorLogo0, uSchool: tutorSchool0, uDesc: tutorDesc0)));
            }
        ),
        ListTile(
            title: Text(tutorEmail1),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProfilePage(uEmail0: uEmail, uName0: uName, uLogo0: uLogo, uName: tutorName1, uEmail: tutorEmail1, uLogo: tutorLogo1, uSchool: tutorSchool1, uDesc: tutorDesc1)));
            }
        ),
        ListTile(
            title: Text(tutorEmail2),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProfilePage(uEmail0: uEmail, uName0: uName, uLogo0: uLogo, uName: tutorName2, uEmail: tutorEmail2, uLogo: tutorLogo2, uSchool: tutorSchool2, uDesc: tutorDesc1)));
            }
        ),
      ],
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
                  mainScreenImg,
                  mainScreenText,
                  descText,
                  itemSelected == true ? tutorList : new Row(),
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
          }),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.uName),
              accountEmail: Text(widget.uEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: uLogo == "blank" ? NetworkImage(firebaseDefaultUserPic): NetworkImage(uLogo),
              ),
            ),
            ExpansionTile(
              title: Text("Academic"),
              trailing: Icon(Icons.assignment),
              children: <Widget>[
                ListTile(
                    title: Text("Maths - Geometry"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("math");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Physics - Chemistry - Biology"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("phy");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Language"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("lang");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Test Preparation"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("test");
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Design"),
              trailing: Icon(Icons.brush),
              children: <Widget>[
                ListTile(
                    title: Text("Web Design"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("web");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Graphic Design"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("grap");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Game Design"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("game");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("3D and Animation"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("3d");
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Music"),
              trailing: Icon(Icons.music_note),
              children: <Widget>[
                ListTile(
                    title: Text("Vocal"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("vocal");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Guitar"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("guitar");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Violin"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("violin");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Piano"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("piano");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Drum"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("drum");
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Photography"),
              trailing: Icon(Icons.photo_camera),
              children: <Widget>[
                ListTile(
                    title: Text("Photography"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("photo");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Photoshop"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("photoS");
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Software Development"),
              trailing: Icon(Icons.laptop_mac),
              children: <Widget>[
                ListTile(
                    title: Text("Programming languages"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("SWlang");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Mobile Development"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("mobile");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Web Development"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("webDev");
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Health and Sport"),
              trailing: Icon(Icons.fitness_center),
              children: <Widget>[
                ListTile(
                    title: Text("Fitness"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("fit");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Yoga - Pilates - Zumba"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("yoga");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Dieting"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("diet");
                      Navigator.of(context).pop();
                    }
                ),
                ListTile(
                    title: Text("Tennis"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      clickCourse("tennis");
                      Navigator.of(context).pop();
                    }
                ),
              ],
            )
          ],
        ),
      ),
      body: body,
    );
  }
}

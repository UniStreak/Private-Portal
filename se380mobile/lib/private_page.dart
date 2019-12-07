import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivatePage extends StatefulWidget {
  static String tag = 'msg-page';
  final String uName;
  final String uEmail; //msg sender
  final String uLogo;
  final String uEmail2; //msg receiver
  PrivatePage({Key key, @required this.uName, @required this.uEmail, @required this.uLogo, @required this.uEmail2}) : super(key: key);
  @override
  _PrivatePageState createState() => new _PrivatePageState(uName, uEmail, uLogo, uEmail2);
}

class _PrivatePageState extends State<PrivatePage> {
  final String uName;
  final String uEmail;
  final String uLogo;
  final String uEmail2;
  _PrivatePageState(this.uName, this.uEmail, this.uLogo, this.uEmail2);
  final messageController = TextEditingController();
  String firebaseDefaultUserPic = 'https://firebasestorage.googleapis.com/v0/b/privateportal-bb133.appspot.com/o/user.png?alt=media&token=d9b5239a-cd7a-4a44-a9f1-7192a97d6ce2';

  Widget messageOnTheRight(String message, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(userName, style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end),
            Text(message, textAlign: TextAlign.end),
          ],
        ),
        Padding(padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: uLogo == "blank" ? NetworkImage(firebaseDefaultUserPic): NetworkImage(uLogo),
            )),
      ],
    );
  }

  Widget messageOnTheLeft(String message, String userName, String userLogo) {
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: uLogo == "blank" ? NetworkImage(firebaseDefaultUserPic): NetworkImage(userLogo),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(userName, style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start),
            Text(message, textAlign: TextAlign.start),
          ],
        )
      ],
    );
  }

  sendMessage(String message) {
    messageController.text = "";
    Map<String, String> data = <String, String>{
      "name": uName,
      "email": uEmail,
      "message": message,
      "date": DateTime.now().toString(),
      "logo": uLogo,
      "to": uEmail2
    };
    Firestore.instance.document("PrivateMessages/" + uEmail + DateTime.now().toString() ).setData(data).whenComplete(() {
      print("Message Sent");
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(uEmail2, style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("PrivateMessages")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                        snapshot.data.documents[index];

                        bool sentMessage = false;
                        if (document['email'] == uEmail) {
                          sentMessage = true;
                        }
                        if ((document['email'] == uEmail && document['to'] == uEmail2)||(document['email'] == uEmail2 && document['to'] == uEmail))
                        return sentMessage
                            ? messageOnTheRight(
                            document['message'], document['name'])
                            : messageOnTheLeft(
                            document['message'], document['name'], document['logo']);
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                ),
              ),
              new Divider(height: 1),
              Container(
                margin: EdgeInsets.all(6),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: messageController,
                        onSubmitted: sendMessage,
                        decoration:
                        new InputDecoration.collapsed(hintText: "Write a message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {
                            sendMessage(messageController.text);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
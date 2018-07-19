import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/PersonData.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseUser user;

  HomeScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            user.photoUrl != null
                ? Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(user.photoUrl),
                        )),
                  )
                : Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: new Icon(
                      Icons.error_outline,
                      color: Colors.white,
                    ),
                  ),
            new SizedBox(
              height: 20.0,
            ),
            new Text(
              user.displayName == null ? user.email : user.displayName,
              style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(user.email),
            new SizedBox(
              height: 20.0,
            ),
            new RaisedButton(
              color: Colors.lightGreenAccent,
              onPressed: () {
                UserAuth auth = new UserAuth();
                auth.signOut();
                Navigator.pop(context);
              },
              child: new Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}

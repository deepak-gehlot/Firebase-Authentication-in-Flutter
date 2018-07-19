import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class PersonData {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
}

class UserAuth {
  String statusMsg = "Account Created Successfully";

  //To create new User
  Future<FirebaseUser> createUser(PersonData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email, password: userData.password);
  }

  //To verify new User
  Future<FirebaseUser> verifyUser(PersonData userData) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth.signInWithEmailAndPassword(
        email: userData.email, password: userData.password);
  }

  /// sign our user
  void signOut() {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
  }

  /// sign in with google
  Future<FirebaseUser> signInWithGoogle() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user;
  }
}

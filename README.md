# flutter_firebase_auth_demo

To use this we need to setup our flutter project, we need to add firebase_auth package and for sign in with google we need to add google_sign_in package in pubspace.yaml file.

```
google_sign_in: "^3.0.4"
firebase_auth: "^0.5.12"
```

Now you need to create project in firebase console https://console.firebase.google.com/ follow this link to create project, and enable sign in method in Authentication tab

## Android setup

#### Open android folder in flutter project now open build.gradle file

```
/// Add the google services classpath
classpath 'com.google.gms:google-services:4.0.0'
```
#### Now open app folder and in this open build.gradle file, It is app level gradle file.

```
/// Add this at bottom of file
apply plugin: 'com.google.gms.google-services'
```
#### now add google-services.json file in app folder which is from firebase console.

## For sign in with google

```
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
```

## For register user

```
//To create new User
Future<FirebaseUser> createUser(PersonData userData) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  return firebaseAuth.createUserWithEmailAndPassword(
      email: userData.email, password: userData.password);
}
```

## For Login user

```
//To verify new User
Future<FirebaseUser> verifyUser(PersonData userData) {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  return firebaseAuth.signInWithEmailAndPassword(
      email: userData.email, password: userData.password);
}
```

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'custom/PasswordField.dart';
import 'model/PersonData.dart';
import 'package:flutter_firebase_auth_demo/HomeScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  PersonData person = new PersonData();
  bool _autovalidate = false;
  bool _isLoading = false;

  /// Validate password field
  String _validatePassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    return null;
  }

  /// Validate email field
  String _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    return null;
  }

  /// Sign in button click
  Widget signInButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.deepOrangeAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () => _handleLoginSubmitted(),
          color: Colors.deepOrangeAccent,
          child: Text(
            'Sign In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Sign UP button click
  Widget signUpButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.deepOrangeAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () => moveToSignUpScreen(),
          color: Colors.deepOrangeAccent,
          child: Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Sign in with Google button click
  Widget loginWithGoogleButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.blueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 180.0,
          onPressed: () => _handleSignIn(),
          color: Colors.blue,
          child: Text(
            'Sign In With Google',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new SizedBox(
                  height: 60.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'images/flutter-logo.png',
                      height: 100.0,
                      width: 100.0,
                    ),
                    new Image.asset(
                      'images/pluse-icon.png',
                      height: 100.0,
                      width: 100.0,
                    ),
                    new Image.asset(
                      'images/firebase-logo.png',
                      height: 100.0,
                      width: 100.0,
                    )
                  ],
                ),
                new SizedBox(
                  height: 60.0,
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter your email address',
                    labelText: 'Email',
                    filled: true,
                  ),
                  validator: _validateEmail,
                  onSaved: (String vale) {
                    person.email = vale;
                  },
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new PasswordField(
                  fieldKey: _passwordFieldKey,
                  helperText: 'No more than 8 characters.',
                  labelText: 'Password',
                  onSaved: (String value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                  validator: _validatePassword,
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new Text(
                  "Forgot Password",
                  textAlign: TextAlign.end,
                  style: new TextStyle(
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.indigo,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    signUpButton(),
                    signInButton(),
                  ],
                ),
                _isLoading
                    ? new Center(
                        child: new CircularProgressIndicator(
                        backgroundColor: Colors.teal,
                      ))
                    : new SizedBox(
                        height: 1.0,
                      ),
                new SizedBox(
                  height: 35.0,
                ),
                Container(
                  child: Center(child: loginWithGoogleButton()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    moveToHomeScreen(user);
    print("signed in " + user.photoUrl);
    return user;
  }

  void _handleLoginSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      UserAuth auth = new UserAuth();
      print(person.email);
      print("password " + person.password);
      auth.verifyUser(person).then((FirebaseUser user) {
        showInSnackBar('Login successfull.');
        setState(() {
          _isLoading = false;
        });
        moveToHomeScreen(user);
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
        showInSnackBar(e);
      });
    }
  }

  void moveToHomeScreen(FirebaseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(user)),
    );
  }

  void moveToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}

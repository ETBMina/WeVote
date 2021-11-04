import 'package:flutter/material.dart';
import 'package:wevote/components/rounded_button.dart';
import 'package:wevote/screens/votes_screen.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/user.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, currentUser, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    //Do something with the user input.
                    password = value;
                  },
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  // make it password field
                  obscureText: true,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password.'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    text: 'Log In',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      //Implement login functionality.
                      // try {
                      //   final user = await _auth.signInWithEmailAndPassword(
                      //       email: email!, password: password!);
                      //
                      //   if (user != null) {
                      //     print('Logged in successfully');
                      //     currentUser = User(email: email!);
                      //
                      //     Navigator.pushNamed(context, VotesScreen.id);
                      //     setState(() {
                      //       showSpinner = false;
                      //     });
                      //   } else
                      //     print('Not looged in');
                      // } on auth.FirebaseAuthException catch (e) {
                      //   if (e.code == 'user-not-found') {
                      //     print('No user found for that email.');
                      //   } else if (e.code == 'wrong-password') {
                      //     print('Wrong password provided for that user.');
                      //   } else if (e.code == 'invalid-email') {
                      //     print('the email address is not valid.');
                      //   } else if (e.code == 'user-disabled') {
                      //     print(
                      //         'the user corresponding to the given email has been disabled.');
                      //   } else
                      //     print(e);
                      // }
                      //TODO make email and password not nullable
                      if (await currentUser.login(
                          email: email!, password: password!)) {
                        print('Logged in successfully');
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context, VotesScreen.id);
                      } else {
                        print('Not looged in');
                      }
                    })
              ],
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/components/rounded_button.dart';
import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/screens/votes_screen.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wevote/models/user/user.dart';

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
    print('scaffold rebuild');
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
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
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
              BlocConsumer<User, UserStates>(
                listener: (context, userState) {
                  if (userState is UserLoggedInState) {
                    setState(() {
                      showSpinner = false;
                    });
                    print('going to push');
                    Navigator.pushNamed(context, VotesScreen.id);
                  }
                },
                buildWhen: (prevState, currentState) {
                  // Don't rebuild widget with state change as it doesn't depend on state
                  return false;
                },
                builder: (context, userState) {
                  User currentUser = User.get(context);
                  print('RoundedButton rebuild');
                  return RoundedButton(
                      color: Colors.lightBlueAccent,
                      text: 'Log In',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        //Implement login functionality.
                        //TODO make email and password not nullable
                        if (await currentUser.login(
                            email: email!, password: password!)) {
                          print('Logged in successfully');
                        } else {
                          print('Not looged in');
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

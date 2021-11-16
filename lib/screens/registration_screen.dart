import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/user/user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:wevote/components/rounded_button.dart';
import 'package:wevote/screens/votes_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '';
  String password = '';
  String fullName = '';
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
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
              // Flexible widgets are used so when no enough space for the child it gets smaller
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
                onChanged: (value) {
                  //Do something with the user input.
                  fullName = value;
                },
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your fullName'),
              ),
              SizedBox(
                height: 8.0,
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
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              BlocConsumer<User, UserStates>(
                listener: (context, userState) {
                  if (userState is UserRegisteredState) {
                    setState(() {
                      showSpinner = false;
                    });
                    print('going to push');
                    Navigator.pushNamed(context, VotesScreen.id);
                  }
                },
                builder: (context, userState) {
                  User currentUser = User.get(context);
                  return RoundedButton(
                      color: Colors.blueAccent,
                      text: 'Register',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        //Implement registration functionality.
                        if (await currentUser.register(
                            email: email,
                            password: password,
                            fullName: fullName)) {
                          print('User registered successfully');
                        } else {
                          print('Not registered');
                        }
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

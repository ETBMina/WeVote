import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/screens/vote_details_screen.dart';
import 'package:wevote/screens/votes_screen.dart';
import 'package:wevote/screens/create_vote_screen.dart';
import 'package:provider/provider.dart';
import 'package:wevote/utilities/bloc_observer.dart';
import 'models/user/user.dart';
import 'models/current_vote_data.dart';
import 'package:wevote/screens/welcome_screen.dart';
import 'package:wevote/screens/login_screen.dart';
import 'package:wevote/screens/registration_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(WeVote());
}

class WeVote extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CurrentVoteData.empty(),
        ),
      ],
      child: BlocProvider(
        create: (BuildContext context) => User.empty(),
        child: MaterialApp(
          title: 'WeVote',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          initialRoute: WelcomeScreen.id,
          routes: {
            VotesScreen.id: (context) => VotesScreen(),
            VoteDetailsScreen.id: (context) => VoteDetailsScreen(),
            CreateVoteScreen.id: (context) => CreateVoteScreen(),
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
          },
        ),
      ),
    );
  }
}

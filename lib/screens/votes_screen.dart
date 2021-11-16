import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/components/refresh_widget.dart';
import 'package:wevote/components/rounded_button.dart';
import 'package:wevote/components/vote_card.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';
import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/screens/add_choice_screen.dart';
import 'package:wevote/screens/vote_details_screen.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:wevote/screens/create_vote_screen.dart';
import 'package:wevote/models/user/user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class VotesScreen extends StatelessWidget {
  static const String id = 'votes_screen';
  String? joinVoteTextFieldValue;

  @override
  Widget build(BuildContext context) {
    print('votes screen build tree');
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: MediaQuery.of(context).size.width / kBestWidth,
        // textScaleFactor: 0.5,
      ),
      child: Scaffold(
        floatingActionButton: SpeedDial(
          icon: IconData(57415, fontFamily: 'MaterialIcons'),
          activeIcon: IconData(57706, fontFamily: 'MaterialIcons'),
          spacing: 5.0,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add_task),
              label: 'Create new vote',
              onTap: () {
                Navigator.pushNamed(context, CreateVoteScreen.id);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.playlist_add),
              label: 'Join a vote',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Join vote'),
                        content: TextField(
                          onChanged: (value) {
                            joinVoteTextFieldValue = value;
                          },
                          decoration:
                              InputDecoration(hintText: "Enter Vote ID here"),
                        ),
                        actions: <Widget>[
                          // TextButton(
                          //   onPressed: () => Navigator.pop(context, 'Cancel'),
                          //   child: const Text('Cancel'),
                          // ),
                          // TextButton(
                          //   onPressed: () => Navigator.pop(context, 'OK'),
                          //   child: const Text('OK'),
                          // ),
                          RoundedButton(
                              color: Colors.blueAccent,
                              text: 'Join',
                              onPressed: () {
                                Navigator.pop(context, 'OK');
                                //TODO handle if voteId is null
                                print(joinVoteTextFieldValue);
                                // TODO Support ModalProgressHUD till joining vote
                                User.get(context)
                                    .joinVote(joinVoteTextFieldValue!);
                              }),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: kBottomNavigationBarSelectedItemColor,
          onTap: (int) {},
        ),
        body: SafeArea(
          child: RefreshWidget(
            onRefresh: () async {
              await User.get(context).loadParticipatedInVotes();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  stretch: true,
                  stretchTriggerOffset: 25,
                  onStretchTrigger: () {
                    // Function callback for stretch
                    return Future<void>.value();
                  },
                  collapsedHeight: kSliverAppBarCollapsedHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    stretchModes: [StretchMode.fadeTitle],
                    title: Text(
                      'WeVote',
                      style: kAppBarTitleTextStyle,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  // 0.4 is the expanded ratio
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  pinned: true,
                ),
                MultiBlocListener(
                  listeners: [
                    BlocListener<User, UserStates>(
                      listener: (context, userState) {},
                    ),
                    BlocListener<CurrentVoteData, CurrentVoteDataStates>(
                      listener: (context, currentVoteDataState) {
                        if (currentVoteDataState
                            is CurrentVoteOpenVoteDetailsState)
                          Navigator.pushNamed(context, VoteDetailsScreen.id);
                      },
                    )
                  ],
                  child: BlocBuilder<User, UserStates>(
                      builder: (context, userState) {
                    User currentUser = User.get(context);
                    print(
                        'userChoices in start of votes screen${User.get(context).userChoices}');
                    CurrentVoteData currentVoteData =
                        CurrentVoteData.get(context);
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          String participatedVoteKey = currentUser
                              .participatedInVotes.keys
                              .elementAt(index);
                          final participatedVote = currentUser
                              .participatedInVotes.values
                              .elementAt(index);
                          return VoteCard(
                            title: participatedVote.title,
                            createdByEmail: participatedVote.createdByEmail,
                            expirationDateTime:
                                participatedVote.expirationDateTime,
                            onCardPressedCallback: () {
                              currentVoteData.openVoteDetails(
                                  voteId: participatedVoteKey,
                                  vote: participatedVote,
                                  userSelection: currentUser
                                      .getUserVoteChoices(participatedVoteKey));
                            },
                          );
                        },
                        childCount: currentUser.participatedInVotes.length,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

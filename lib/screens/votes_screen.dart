import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/components/vote_card.dart';
import 'package:wevote/models/current_vote_data.dart';
import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/screens/vote_details_screen.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:wevote/screens/create_vote_screen.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/user/user.dart';

class VotesScreen extends StatelessWidget {
  static const String id = 'votes_screen';

  @override
  Widget build(BuildContext context) {
    // currentVoteData = CurrentVoteData.newVote(currentUser.email);
    print('votes screen build tree');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // currentVoteData.resetVoteData();
          Navigator.pushNamed(context, CreateVoteScreen.id);
        },
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
            Consumer<CurrentVoteData>(
                builder: (context, currentVoteData, child) {
              print('votes list rebuilt');
              return BlocConsumer<User, UserStates>(
                  listener: (context, userState) {},
                  builder: (context, userState) {
                    User currentUser = User.get(context);
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
                              print('on vote pressed called');
                              currentVoteData =
                                  CurrentVoteData.newVote(currentUser.email);
                              // currentVoteData = CurrentVoteData(
                              //     voteId: participatedVoteKey,
                              //     currentVote: participatedVote,
                              //     userSelection: currentUser
                              //         .getUserVoteChoices(participatedVoteKey));
                              currentVoteData.voteId = participatedVoteKey;
                              currentVoteData.currentVote = participatedVote;
                              currentVoteData
                                  .changeTitle(participatedVote.title);
                              // print(currentVoteData.userSelection);
                              print(currentUser
                                  .getUserVoteChoices(participatedVoteKey));
                              currentVoteData.userSelection = currentUser
                                  .getUserVoteChoices(participatedVoteKey);
                              print(currentVoteData.userSelection);
                              // currentVoteData.notifyListenersAboutChanges();
                              print(
                                  'currentVoteData in votes_screen: ${currentVoteData.currentVote.toJson()}');
                              print(
                                  'userSelections in votes_screen: ${currentUser.getUserVoteChoices(participatedVoteKey)}');
                              Navigator.pushNamed(
                                  context, VoteDetailsScreen.id);
                            },
                          );
                        },
                        childCount: currentUser.participatedInVotes.length,
                      ),
                    );
                  });
            })
          ],
        ),
      ),
    );
  }
}

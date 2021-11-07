import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/components/radio_choice_tile.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';

// This is a test data TODO remove it
// var vote = Vote(
//   isPublic: true,
//   isSecretVote: false,
//   title:
//       'Who is d the best playerrrrrrrrr rrrrrrr rrrrrr rrrrr rrrrrr rrr rrrrrrr?',
//   description:
//       'This vote is about who is the best football player in the world',
//   choices: {
//     'Messi': 1,
//     'Ronaldo': 1,
//     'Neymar': 1,
//   },
//   createdByEmail: 'mina@gmail.com',
//   isAddingChoicesAllowed: false,
//   noOfChoicesToSelect: 1,
//   isOrderMaters: false,
//   createdDateTime: DateTime.now(),
//   rankingWeights: [],
//   expirationDateTime: DateTime.now().add(Duration(days: 3)),
// );

class RadioChoicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentVoteData, CurrentVoteDataStates>(
      buildWhen: (prevState, currState) {
        return currState is CurrentVoteChangeUserSelectionState;
      },
      builder: (context, currentVoteDataState) {
        CurrentVoteData currentVoteData = CurrentVoteData.get(context);
        var currentVote = currentVoteData.currentVote;
        //TODO remove below comment
        // List<String> choices = vote.choices.keys.toList();
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: currentVote.choices.length,
          itemBuilder: (context, index) {
            final currentChoice = currentVote.choices.keys.elementAt(index);
            return RadioChoiceTile(
                choiceTitle: currentChoice,
                isSelected: false,
                onPressCallback: () {});
          },
        );
      },
    );
  }
}

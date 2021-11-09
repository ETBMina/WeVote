import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/components/radio_choice_tile.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';

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

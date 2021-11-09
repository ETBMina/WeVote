import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/components/new_choice_tile.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';

class NewChoicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentVoteData, CurrentVoteDataStates>(
      listener: (context, currentVoteDataState) {},
      buildWhen: (prevState, currState) {
        return currState is CurrentVoteAddNewChoiceState;
      },
      builder: (context, currentVoteDataState) {
        CurrentVoteData currentVoteData = CurrentVoteData.get(context);
        final choices = currentVoteData.currentVote.choices.keys;
        return Column(
          children: choices.map((choice) => NewChoiceTile(choice)).toList(),
        );
      },
    );
  }
}

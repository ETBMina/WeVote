import 'package:flutter/material.dart';
import 'package:wevote/components/new_choice_tile.dart';
import 'package:wevote/models/current_vote_data.dart';
import 'package:provider/provider.dart';

class NewChoicesList extends StatelessWidget {
  // final List<String> choices;

  // NewChoicesList(this.choices);

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentVoteData>(
      builder: (context, currentVoteData, child) {
        final choices = currentVoteData.currentVote.choices.keys;
        return Column(
          children: choices.map((choice) => NewChoiceTile(choice)).toList(),
        );
      },
    );
  }
}

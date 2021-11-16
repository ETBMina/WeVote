import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';

class WinnersList extends StatelessWidget {
  const WinnersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentVoteData, CurrentVoteDataStates>(
      buildWhen: (prevState, currState) {
        return currState is CurrentVoteChangeUserSelectionState;
      },
      builder: (context, currentVoteDataState) {
        CurrentVoteData currentVoteData = CurrentVoteData.get(context);
        var currentVote = currentVoteData.currentVote;
        SplayTreeMap<String, int> winners = currentVote.calculateWinners();
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: currentVote.choices.length,
          itemBuilder: (context, index) {
            final currentChoice = winners.keys.elementAt(index);
            return ListTile(
              title: Row(
                children: [
                  Text(
                    '${(index + 1)}. $currentChoice',
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: index == 0
                        ? Icon(
                            Icons.emoji_events,
                            color: Colors.yellow[800],
                          )
                        : null,
                  ),
                ],
              ),

              // title: Text(currentChoice),
              // leading: Text((index + 1).toString()),
              // horizontalTitleGap: 5,
            );
          },
        );
      },
    );
  }
}

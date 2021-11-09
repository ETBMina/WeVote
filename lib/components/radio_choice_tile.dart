import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';
import 'package:wevote/models/user/user.dart';

class RadioChoiceTile extends StatefulWidget {
  final String choiceTitle;
  final bool isSelected;
  final Function onPressCallback;
  static String? selectedChoice = '';

  RadioChoiceTile(
      {required this.choiceTitle,
      required this.isSelected,
      required this.onPressCallback});

  @override
  _RadioChoiceTileState createState() => _RadioChoiceTileState();
}

class _RadioChoiceTileState extends State<RadioChoiceTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentVoteData, CurrentVoteDataStates>(
        buildWhen: (prevState, currState) {
      return currState is CurrentVoteChangeUserSelectionState;
    }, builder: (context, currentVoteDataState) {
      CurrentVoteData currentVoteData = CurrentVoteData.get(context);
      return RadioListTile(
        title: Text(widget.choiceTitle),
        // This is the value of the choice, which should be constant for every choice
        value: widget.choiceTitle,
        // This is the selected choice value across all radio list tiles
        groupValue: currentVoteData.userSelection.length == 0
            ? ''
            : currentVoteData.userSelection[0],
        onChanged: (String? selectedValue) {
          currentVoteData.changeFirstSelection(selectedValue ?? '');
        },
      );
    });
  }
}

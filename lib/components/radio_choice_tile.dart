import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/current_vote_data.dart';
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
    return Consumer<CurrentVoteData>(
        builder: (context, currentVoteData, child) {
      return RadioListTile(
        title: Text(widget.choiceTitle),
        // This is the value of the choice, which should be constant for every choice
        value: widget.choiceTitle,
        // This is the selected choice value across all radio list tiles
        groupValue: currentVoteData.userSelection.length == 0
            ? ''
            : currentVoteData.userSelection[0],
        onChanged: (String? selectedValue) {
          // print(
          //     'userChoices in RadioChoiceTile${Provider.of<User>(context, listen: false).userChoices}');
          currentVoteData.changeFirstSelection(selectedValue ?? '');
          // print(
          //     'currentVoteData userSelection in radio:${currentVoteData.userSelection}');
          // print(
          //     'userChoices in RadioChoiceTile${Provider.of<User>(context, listen: false).userChoices}');
        },
      );
    });
  }
}

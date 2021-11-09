import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';

class AddChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String newChoiceTitle = 'showModalBottomSheet';

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Choice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newChoiceTitle = newText;
              },
            ),
            BlocListener<CurrentVoteData, CurrentVoteDataStates>(
              listener: (context, currentVoteDataState) {
                if (currentVoteDataState is CurrentVoteAddNewChoiceState) {
                  // Dismiss the keyboard
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                }
              },
              child: FlatButton(
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  CurrentVoteData.get(context).addChoice(newChoiceTitle);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

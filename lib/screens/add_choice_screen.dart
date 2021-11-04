import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/current_vote_data.dart';

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
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                Provider.of<CurrentVoteData>(context, listen: false)
                    .addChoice(newChoiceTitle);
                // Dismiss the keyboard
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

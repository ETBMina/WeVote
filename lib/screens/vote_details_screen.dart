import 'package:flutter/material.dart';
import 'package:wevote/components/radio_choices_list.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/current_vote_data.dart';
import 'package:wevote/models/user/user.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:wevote/components/rounded_button.dart';

class VoteDetailsScreen extends StatelessWidget {
  static const String id = 'vote_details_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentVoteData>(
        builder: (context, currentVoteData, child) {
      // print(
      //     'currentVoteData in votedetails: ${currentVoteData.currentVote.toJson()}');
      // print('userSelections in votedetails: ${currentVoteData.userSelection}');
      // print(
      //     'userChoices in votedetails${Provider.of<User>(context, listen: false).userChoices}');
      return Scaffold(
        body: Column(
          children: [
            // Widget: Title card
            Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Widget
                  Container(
                    width: double.infinity,
                    color: kCardContainerTitleBackgroundColor,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            currentVoteData.currentVote.title,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Description Widget
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      currentVoteData.currentVote.description,
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  // Created By Row:
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Text(
                          'Created By:  ',
                          style: kCardHeadingsTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            '${currentVoteData.currentVote.createdByEmail}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kCardBodyTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Expire Date and Icons Row:
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Expire Date: ',
                          style: kCardHeadingsTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '${DateFormat("dd-MM-yyyy H:m").format(currentVoteData.currentVote.expirationDateTime)}',
                          style: kCardBodyTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(child: SizedBox()),
                        // Secret Icon
                        Icon(
                          Icons.lock,
                          color: Colors.red[700],
                          size: kCardIconSize,
                        ),
                        // publicity Icon:
                        Icon(
                          Icons.public,
                          color: Colors.blue[900],
                          size: kCardIconSize,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Earth",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Moon",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text(
                                  "Sun",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            // child: Ink(
                            //   decoration: const ShapeDecoration(
                            //     shape: CircleBorder(),
                            //   ),
                            //   child: Icon(Icons.more_vert),
                            // ),
                            icon: Icon(Icons.more_vert),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Choices List:
            Expanded(
              child: RadioChoicesList(),
            ),
            // Buttons Row:
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Submit Button
                RoundedButton(
                    color: Colors.blueAccent,
                    text: 'Submit',
                    onPressed: () {
                      // currentUser.submitChoices(currentVoteData.voteId,
                      //     currentVoteData.userSelection);
                    }),
                RoundedButton(
                    color: Colors.blueAccent, text: 'Cancel', onPressed: () {}),
              ],
            ),
          ],
        ),
      );
    });
  }
}
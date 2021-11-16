import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/components/radio_choices_list.dart';
import 'package:wevote/components/winners_list.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';
import 'package:wevote/models/user/user.dart';
import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/models/vote.dart';
import 'package:wevote/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:wevote/components/rounded_button.dart';
import 'package:flutter/services.dart';

enum VoteAction { end, share, delete }

class VoteDetailsScreen extends StatelessWidget {
  static const String id = 'vote_details_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CurrentVoteData, CurrentVoteDataStates>(
          listener: (context, currentVoteDataState) {},
          builder: (context, currentVoteDataState) {
            CurrentVoteData currentVoteData = CurrentVoteData.get(context);
            print('vote details screen rebuild');
            return Column(
              children: [
                // Widget: Title and details card
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
                              child: PopupMenuButton<VoteAction>(
                                onSelected: (VoteAction selectedAction) async {
                                  if (selectedAction == VoteAction.end) {
                                    await User.get(context)
                                        .endVote(currentVoteData.voteId);
                                    currentVoteData.calculateWinners();
                                  } else if (selectedAction ==
                                      VoteAction.delete) {
                                    await User.get(context)
                                        .deleteVote(currentVoteData.voteId);
                                    Navigator.pop(context);
                                  } else {
                                    Clipboard.setData(ClipboardData(
                                        text: currentVoteData.voteId));
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem<VoteAction>(
                                    value: VoteAction.end,
                                    child: Text(
                                      "End Vote",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  PopupMenuItem<VoteAction>(
                                    value: VoteAction.share,
                                    child: Text(
                                      "Share",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  PopupMenuItem<VoteAction>(
                                    value: VoteAction.delete,
                                    child: Text(
                                      "Delete",
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
                Expanded(
                  child: currentVoteData.currentVote.status == Status.completed
                      ? VoteWinners(currentVoteData: currentVoteData)
                      : VoteChoices(currentVoteData: currentVoteData),
                )

                // Expanded(
                //   child: VoteChoices(currentVoteData: currentVoteData),
                // ),
              ],
            );
          }),
    );
  }
}

class VoteWinners extends StatelessWidget {
  const VoteWinners({
    Key? key,
    required this.currentVoteData,
  }) : super(key: key);

  final CurrentVoteData currentVoteData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: WinnersList()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RoundedButton(
              color: Colors.blueAccent,
              text: 'Done',
              onPressed: () async {
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}

class VoteChoices extends StatelessWidget {
  const VoteChoices({
    Key? key,
    required this.currentVoteData,
  }) : super(key: key);

  final CurrentVoteData currentVoteData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Choices List:
        Expanded(
          child: RadioChoicesList(),
        ),
        // Buttons Row:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Submit Button
              Expanded(
                child: BlocListener<User, UserStates>(
                  listener: (context, userState) {
                    if (userState is UserSubmitChoicesState) {
                      Navigator.pop(context);
                    }
                  },
                  child: RoundedButton(
                      color: Colors.blueAccent,
                      text: 'Submit',
                      onPressed: () async {
                        // currentUser.submitChoices(currentVoteData.voteId,
                        //     currentVoteData.userSelection);
                        await User.get(context).submitChoices(
                            currentVoteData.voteId,
                            currentVoteData.userSelection);
                      }),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: RoundedButton(
                    color: Colors.blueAccent,
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

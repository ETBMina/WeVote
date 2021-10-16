import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wevote/models/vote.dart';
import 'package:intl/intl.dart';
import 'package:wevote/utilities/constants.dart';

// This is a test data
var vote = Vote(
  isPublic: true,
  isSecretVote: false,
  title:
      'Who is d the best playerrrrrrrrr rrrrrrr rrrrrr rrrrr rrrrrr rrr rrrrrrr?',
  description:
      'This vote is about who is the best football player in the world',
  choices: {
    'Messi': 1,
    'Ronaldo': 1,
    'Neymar': 1,
  },
  createdByEmail: 'mina@gmail.com',
  isAddingChoicesAllowed: false,
  noOfChoicesToSelect: 1,
  isOrderMaters: false,
  createdDateTime: DateTime.now(),
  rankingWeights: [],
  expirationDateTime: DateTime.now().add(Duration(days: 3)),
);

class VoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kCardPadding,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCardBorderRadius)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Column(
            children: [
              Container(
                color: kCardContainerTitleBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(kCardTitlePadding),
                  child: Center(
                    child: Text(
                      vote.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kCardTitleFontSize,
                        color: kCardTitleTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kCardBodyPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Created By:  ',
                                    style: kCardHeadingsTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${vote.createdByEmail}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: kCardBodyTextStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Expire Date: ',
                                    style: kCardHeadingsTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    '${DateFormat("dd-MM-yyyy H:m").format(vote.expirationDateTime)}',
                                    style: kCardBodyTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.lock,
                          color: Colors.red[700],
                          size: kCardIconSize,
                        ),
                        Icon(
                          Icons.public,
                          color: Colors.blue[900],
                          size: kCardIconSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

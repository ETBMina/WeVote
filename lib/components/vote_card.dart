import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wevote/models/vote.dart';
import 'package:intl/intl.dart';

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
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 25,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Column(
            children: [
              Container(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      vote.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.blueAccent,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${vote.createdByEmail}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Expire Date: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.blueAccent,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    '${DateFormat("dd-MM-yyyy H:m").format(vote.expirationDateTime)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
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
                          size: 35,
                        ),
                        Icon(
                          Icons.public,
                          color: Colors.blue[900],
                          size: 35,
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

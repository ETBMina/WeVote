import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wevote/utilities/constants.dart';

class VoteCard extends StatelessWidget {
  final String title;
  final DateTime expirationDateTime;
  final String createdByEmail;
  final VoidCallback onCardPressedCallback;

  VoteCard(
      {required this.title,
      required this.expirationDateTime,
      required this.createdByEmail,
      required this.onCardPressedCallback});

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
          onTap: onCardPressedCallback,
          child: Column(
            children: [
              Container(
                color: kCardContainerTitleBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(kCardTitlePadding),
                  child: Center(
                    child: Text(
                      title,
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
                                      '${createdByEmail}',
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
                                    '${DateFormat("dd-MM-yyyy H:m").format(expirationDateTime)}',
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

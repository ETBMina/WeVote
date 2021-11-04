import 'package:flutter/material.dart';

//Login screen constants:
const kTextFieldDecoration = InputDecoration(
  hintText: 'Hint text',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
// VoteCard constants:

const kCardIconSize = 35.0;
const kCardBorderRadius = 15.0;
const kCardTitlePadding = 8.0;
const kCardBodyPadding = 20.0;
const kCardTitleFontSize = 20.0;
const kCardContainerTitleBackgroundColor = Colors.blueAccent;
const kCardTitleTextColor = Colors.white;

const kCardHeadingsTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 17,
  color: Colors.blueAccent,
);
const kCardBodyTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
);
const kCardPadding = EdgeInsets.symmetric(
  vertical: 8,
  horizontal: 25,
);

// VotesScreen constants:
const kBottomNavigationBarSelectedItemColor = Colors.blueAccent;
final kAppBarTitleTextStyle =
    TextStyle(fontSize: 40.0, color: Colors.blue[900]);
const kSliverAppBarCollapsedHeight = 70.0;

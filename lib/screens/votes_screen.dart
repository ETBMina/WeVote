import 'package:flutter/material.dart';
import 'package:wevote/components/vote_card.dart';
import 'package:wevote/utilities/constants.dart';

class VotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: kBottomNavigationBarSelectedItemColor,
        onTap: (int) {},
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              stretch: true,
              stretchTriggerOffset: 25,
              onStretchTrigger: () {
                // Function callback for stretch
                print('hello');
                return Future<void>.value();
              },
              collapsedHeight: kSliverAppBarCollapsedHeight,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                stretchModes: [StretchMode.fadeTitle],
                title: Text(
                  'WeVote',
                  style: kAppBarTitleTextStyle,
                ),
              ),
              backgroundColor: Colors.white,
              // 0.4 is the expanded ratio
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              VoteCard(),
              VoteCard(),
              VoteCard(),
              VoteCard(),
              VoteCard(),
              VoteCard(),
              VoteCard(),
              VoteCard(),
            ]))
          ],
        ),
      ),
    );
  }
}

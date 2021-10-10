import 'package:flutter/material.dart';

class VotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('WeVote'),
            // The bottom bar row
            Row(
              children: [
                TextButton(
                  // TODO: Create home button onPressed
                  onPressed: () {},
                  child: Icon(Icons.home),
                ),
                TextButton(
                  // TODO: Create settings button onPressed
                  onPressed: () {},
                  child: Icon(Icons.settings),
                ),
                TextButton(
                  // TODO: Create avatar button onPressed
                  onPressed: () {},
                  child: CircleAvatar(
                    radius: 50.0,
                    // TODO: Make the profile picture dynamic
                    backgroundImage: AssetImage('images/profilePicture.JPG'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

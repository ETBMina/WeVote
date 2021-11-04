import 'package:wevote/models/vote.dart';
import 'package:flutter/foundation.dart';

class CurrentVoteData extends ChangeNotifier {
  String voteId;
  Vote currentVote;
  List<String> userSelection;

  CurrentVoteData(
      {required this.voteId,
      required this.currentVote,
      required this.userSelection});

  CurrentVoteData.newVote(String createdByEmail)
      : voteId = 'tempVoteId',
        currentVote = Vote.emailOnly(createdByEmail),
        userSelection = [];

  CurrentVoteData.empty()
      : voteId = 'tempVoteId',
        currentVote = Vote.empty(),
        userSelection = [];

  void changeFirstSelection(String newSelectedValue) {
    if (userSelection.length == 0) {
      userSelection.add(newSelectedValue);
    } else
      userSelection[0] = newSelectedValue;
    notifyListeners();
  }

  void resetVoteData() {
    // Save email as it will be the same
    String email = currentVote.createdByEmail;
    currentVote = Vote.emailOnly(email);
    userSelection = [];
  }

  void addChoice(String newChoiceTitle) {
    currentVote.choices[newChoiceTitle] = 1;
    notifyListeners();
  }

  void changeTitle(String newTitle) {
    currentVote.title = newTitle;
    notifyListeners();
  }

  void notifyListenersAboutChanges() {
    notifyListeners();
  }
}

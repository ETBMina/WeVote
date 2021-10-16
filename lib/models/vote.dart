import 'dart:collection';

class Vote {
  bool isPublic;
  final bool isSecretVote;
  String title;
  String description;
  final String createdByEmail;
  Map<String, int> choices;
  bool isAddingChoicesAllowed;
  int noOfChoicesToSelect;
  final bool isOrderMaters;
  List<int> rankingWeights;
  final DateTime createdDateTime;
  DateTime expirationDateTime;

  Vote(
      {required this.isPublic,
      required this.isSecretVote,
      required this.title,
      required this.description,
      required this.createdByEmail,
      required this.choices,
      required this.isAddingChoicesAllowed,
      required this.noOfChoicesToSelect,
      required this.isOrderMaters,
      required this.rankingWeights,
      required this.createdDateTime,
      required this.expirationDateTime});

  void togglePublic() {
    isPublic = !isPublic;
  }

  void toggleAddingChoicesAllowed() {
    isAddingChoicesAllowed = !isAddingChoicesAllowed;
  }

  void addChoice(String newChoice) {
    choices[newChoice] = 1;
  }

  bool isExpired() {
    // if expiration date is not reached yet
    if (expirationDateTime.isAfter(DateTime.now())) {
      return false;
    } else {
      return true;
    }
  }

  SplayTreeMap<String, int> calculateWinners() {
    SplayTreeMap<String, int> sortedWinners = SplayTreeMap.from(
        choices, (key1, key2) => choices[key1]!.compareTo(choices[key2]!));
    return sortedWinners;
  }
}

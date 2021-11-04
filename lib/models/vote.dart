import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
/// use "flutter pub run build_runner build" to generate it.
part 'vote.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Vote {
  bool isPublic;
  bool isSecretVote;
  String title;
  String description;
  String createdByEmail;
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
      List<int>? rankingWeights,
      required this.createdDateTime,
      required this.expirationDateTime})
      : rankingWeights = rankingWeights ?? [];

  Vote.empty()
      : createdByEmail = '',
        isOrderMaters = false,
        createdDateTime = DateTime.now(),
        isPublic = true,
        isSecretVote = true,
        title = '',
        description = '',
        choices = {},
        isAddingChoicesAllowed = false,
        noOfChoicesToSelect = 1,
        expirationDateTime = DateTime.now(),
        rankingWeights = [];

  Vote.emailOnly(this.createdByEmail)
      : isOrderMaters = false,
        createdDateTime = DateTime.now(),
        isPublic = true,
        isSecretVote = true,
        title = '',
        description = '',
        choices = {},
        isAddingChoicesAllowed = false,
        noOfChoicesToSelect = 1,
        expirationDateTime = DateTime.now(),
        rankingWeights = [];

  /// A necessary factory constructor for creating a new Vote instance
  /// from a map. Pass the map to the generated `_$VoteFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Vote.
  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$VoteToJson`.
  Map<String, dynamic> toJson() => _$VoteToJson(this);

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

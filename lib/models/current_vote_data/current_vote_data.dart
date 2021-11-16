import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';
import 'package:wevote/models/vote.dart';

class CurrentVoteData extends Cubit<CurrentVoteDataStates> {
  String voteId;
  Vote currentVote;
  List<String> userSelection;
  SplayTreeMap<String, int> winners;
  static CurrentVoteData get(context) => BlocProvider.of(context);

  CurrentVoteData(
      {required this.voteId,
      required this.currentVote,
      required this.userSelection})
      : winners = SplayTreeMap<String, int>(),
        super(CurrentVoteInitialState());

  CurrentVoteData.newVote(String createdByEmail)
      : voteId = 'tempVoteId',
        currentVote = Vote.emailOnly(createdByEmail),
        userSelection = [],
        winners = SplayTreeMap<String, int>(),
        super(CurrentVoteInitialState());

  CurrentVoteData.empty()
      : voteId = 'tempVoteId',
        currentVote = Vote.empty(),
        userSelection = [],
        winners = SplayTreeMap<String, int>(),
        super(CurrentVoteInitialState());

  void openVoteDetails(
      {required String voteId,
      required Vote vote,
      required List<String> userSelection}) {
    this.voteId = voteId;
    this.currentVote = vote;
    this.userSelection = List.from(userSelection);
    emit(CurrentVoteOpenVoteDetailsState());
  }

  void changeFirstSelection(String newSelectedValue) {
    if (userSelection.length == 0) {
      userSelection.add(newSelectedValue);
    } else
      userSelection[0] = newSelectedValue;
    emit(CurrentVoteChangeUserSelectionState());
  }

  void resetVoteData(String createdByEmail) {
    // // Save email as it will be the same
    // String email = currentVote.createdByEmail;
    currentVote = Vote.emailOnly(createdByEmail);
    voteId = '';
    userSelection = [];
    emit(CurrentVoteResetVoteDataState());
  }

  void addChoice(String newChoiceTitle) {
    currentVote.choices[newChoiceTitle] = 1;
    emit(CurrentVoteAddNewChoiceState());
  }

  void changeTitle(String newTitle) {
    currentVote.title = newTitle;
    emit(CurrentVoteChangeTitleState());
  }

  void toggleIsPublic() {
    currentVote.togglePublic();
    emit(CurrentVoteToggleIsPublicState());
  }

  void toggleIsSecret() {
    currentVote.toggleIsSecret();
    emit(CurrentVoteToggleIsSecretState());
  }

  void toggleIsAddingChoicesAllowed() {
    currentVote.toggleAddingChoicesAllowed();
    emit(CurrentVoteToggleIsAddingChoicesAllowedState());
  }

  void calculateWinners() {
    winners = currentVote.calculateWinners();
    emit(CurrentVoteEndVoteState());
  }

// void notifyListenersAboutChanges() {
  //   notifyListeners();
  // }
  // SplayTreeMap<String, int> endVoteAndGetWinners() {
  //   currentVote.markVoteAsCompleted();
  //   return currentVote.calculateWinners();
  // }
}

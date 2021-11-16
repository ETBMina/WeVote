import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/models/vote.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

final _auth = auth.FirebaseAuth.instance;

class User extends Cubit<UserStates> {
  String fullName;
  String email;
  Map<String, Vote> participatedInVotes;
  Map<String, List<String>> userChoices;

  static User get(context) => BlocProvider.of(context);

  User(
      {String? fullName,
      required this.email,
      Map<String, Vote>? participatedInVotes,
      Map<String, List<String>>? userChoices})
      : participatedInVotes = participatedInVotes ?? {},
        userChoices = userChoices ?? {},
        fullName = fullName ?? '',
        super(UserInitialState());

  User.empty()
      : email = '',
        fullName = '',
        participatedInVotes = {},
        userChoices = {},
        super(UserInitialState());

  Future<bool> register(
      {required String email,
      required String password,
      required fullName}) async {
    try {
      //Empty participatedInVotes TODO try to solve this bug
      participatedInVotes = {};
      // register
      auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      this.email = userCredential.user!.email!;
      // Sets the user displayName
      if (await updateUserName(fullName)) {
        this.fullName = fullName;
        // Create an empty record in user details collection for the new user, and return it's success status

        if (await createUserDetailsDocument()) {
          emit(UserRegisteredState());
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('there already exists an account with the given email address.');
      } else if (e.code == 'invalid-email') {
        print('the email address is not valid.');
      } else if (e.code == 'operation-not-allowed') {
        print(
            'email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.');
      } else if (e.code == 'weak-password') {
        print('the password is not strong enough.');
      } else
        print(e);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      //sign in
      auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      this.email = userCredential.user!.email!;
      // Get the user displayName stored in the database, and store it in the fullName
      this.fullName = userCredential.user!.displayName ?? '';
      // Load participatedInVotes and userChoices from the database
      await loadParticipatedInVotes();
      emit(UserLoggedInState());
      return true;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('the email address is not valid.');
      } else if (e.code == 'user-disabled') {
        print('the user corresponding to the given email has been disabled.');
      } else
        print(e);
      return false;
    }
  }

  auth.User? getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return user;
      }
    } catch (e) {
      print(e);
    }
  }

  // TODO make createVote returns bool
  void createVote(String tempId, Vote newVote) async {
    CollectionReference votesRef =
        FirebaseFirestore.instance.collection('votes');
    try {
      DocumentReference documentRef = await votesRef.add(newVote.toJson());
      // Add the new vote to the participatedInVotes
      participatedInVotes[documentRef.id] = newVote;
      // Add the new vote to the userChoices and set its value to empty list as user doesn't choose any yet.
      userChoices[documentRef.id] = [];
      // Add the new vote to the userChoices in the database
      addVoteToUserData();
      // Notify listeners about the new vote
      // notifyListeners();
      emit(UserCreateVoteState());
    } catch (e) {
      print(e);
    }
  }

  // Add the local userChoices to the database
  Future<bool> addVoteToUserData() async {
    try {
      print('addVoteToUserData called');
      CollectionReference userDetailsRef =
          FirebaseFirestore.instance.collection('user details');
      Map<String, Map<String, List<String>>> userChoices = {
        'userChoices': this.userChoices
      };
      await userDetailsRef.doc(_auth.currentUser!.uid).update(userChoices);
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  // Create a document in user details database collection, used when registering a new user
  Future<bool> createUserDetailsDocument() async {
    CollectionReference userDetailsRef =
        FirebaseFirestore.instance.collection('user details');
    try {
      // the document will contain empty "userChoices" at the beginning:
      Map<String, dynamic> emptyMap = {'userChoices': []};
      await userDetailsRef.doc(_auth.currentUser!.uid).set(emptyMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Update the user displayName stored in the database as well as the local fullName
  Future<bool> updateUserName(String fullName) async {
    await _auth.currentUser!.updateDisplayName(fullName);
    // check if the displayName is already changed
    if (_auth.currentUser!.displayName == fullName) {
      // name changes successfully
      // update the local user fullName
      this.fullName = fullName;
      emit(UserUpdateDisplayNameState());
      return true;
    } else {
      // Name is not changed
      return false;
    }
  }

  List<String> getUserVoteChoices(String voteId) {
    return userChoices[voteId] ?? [];
  }

  DocumentReference _getUserDetailsDocRef() {
    return FirebaseFirestore.instance
        .collection('user details')
        .doc(_auth.currentUser!.uid);
  }

  // TODO make it return bool
  Future<void> loadParticipatedInVotes() async {
    DocumentReference userDetailsRef = _getUserDetailsDocRef();
    CollectionReference votesRef =
        FirebaseFirestore.instance.collection('votes');
    // Get user choices
    DocumentSnapshot userDetailsDocRef = await userDetailsRef.get();
    // Convert the fetched userChoices to Map<String, dynamic>
    var temp = await userDetailsDocRef['userChoices'];
    // If temp is List, this means that userChoices fetched is empty
    if (temp is List) {
      // Let userChoices be empty map
      userChoices = {};
    } else {
      temp = temp as Map<String, dynamic>;
      userChoices = (temp).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      );
    }

    // Empty participatedInVotes
    // TODO this is a bug that the User instance should be created when logging or registering as not to take the prev data
    participatedInVotes = {};
    // Looping the userChoices and get the vote data for each vote the user is participating in:
    for (var voteId in userChoices.keys) {
      DocumentSnapshot vote = await votesRef.doc(voteId).get();
      Map<String, dynamic> voteData = vote.data() as Map<String, dynamic>;
      participatedInVotes[voteId] = Vote.fromJson(voteData);
    }
    emit(UserLoadParticipatedInVotesState());
  }

  Future<bool> submitChoices(String voteId, List<String> userSelections) async {
    print('submitChoices called');
    // Get the new choices that the user has checked
    Set<String> newChoices =
        userSelections.toSet().difference(userChoices[voteId]!.toSet());
    // Get the choices that the user has unchecked
    Set<String> removedChoices =
        userChoices[voteId]!.toSet().difference(userSelections.toSet());

    //Update the choices voting in DB
    incDecChoiceVoting(voteId, newChoices, true);
    incDecChoiceVoting(voteId, removedChoices, false);

    // update local user choices
    this.userChoices[voteId] = List.from(userSelections);

    // update database user choices
    if (await addVoteToUserData()) {
      emit(UserSubmitChoicesState());
      return true;
    }
    return false;
  }

  // This method is used for incrementing or decrementing choices value
  Future<bool> incDecChoiceVoting(
      String voteId, Set<String> choices, bool isIncrement) async {
    CollectionReference votesRef =
        FirebaseFirestore.instance.collection('votes');
    int incrementValue = isIncrement ? 1 : -1;
    for (String choice in choices) {
      await votesRef
          .doc(voteId)
          .update({"choices.$choice": FieldValue.increment(incrementValue)});
    }
    return true;
  }

  Future<bool> joinVote(String voteId) async {
    // Add to userChoices
    //TODO support if DB adding fails, rollback
    userChoices[voteId] = [];
    // Add userChoices to userDetails collection:
    addVoteToUserData();
    // Fetch vote data from Firebase:
    CollectionReference votesRef =
        FirebaseFirestore.instance.collection('votes');
    // TODO: add the following code to a function as it is used in diff places
    DocumentSnapshot vote = await votesRef.doc(voteId).get();
    Map<String, dynamic> voteData = vote.data() as Map<String, dynamic>;
    participatedInVotes[voteId] = Vote.fromJson(voteData);
    emit(UserJoinVoteState());
    //TODO return the actual state
    return true;
  }

  Future<void> endVote(String voteId) async {
    //TODO what happens if not authorized
    // Check If current user is authorized to end vote:
    if (participatedInVotes[voteId]!.createdByEmail == email) {
      // user is authorized
      // Fetch vote data from Firebase:
      DocumentReference voteDoc =
          FirebaseFirestore.instance.collection('votes').doc(voteId);
      DocumentSnapshot voteData = await voteDoc.get();
      // Update choices to calculate winners:
      participatedInVotes[voteId]!.choices = Map.from(voteData['choices']);
      // Set vote Status completed:
      await voteDoc.update({'status': "completed"});
      participatedInVotes[voteId]!.status = Status.completed;
      print(participatedInVotes[voteId]!.calculateWinners());
      // emit(state)
    }
  }

  Future<void> deleteVote(String voteId) async {
    //TODO what happens if not authorized
    // Check If current user is authorized to end vote:
    if (participatedInVotes[voteId]!.createdByEmail == email) {
      // Delete vote Document:
      await FirebaseFirestore.instance.collection('votes').doc(voteId).delete();
      CollectionReference userDetailsCollection =
          FirebaseFirestore.instance.collection('user details');
      print(voteId);
      // Query for users that is participated in the vote
      var docs =
          userDetailsCollection.where('userChoices.$voteId', isNull: false);
      await docs.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          // Delete vote field from userChoices
          document.reference
              .update({'userChoices.$voteId': FieldValue.delete()});
        });
      });
      // Delete vote from local userChoices and participatedInVotes
      userChoices.remove(voteId);
      participatedInVotes.remove(voteId);

      emit(UserDeleteVoteState());
    }
  }
}

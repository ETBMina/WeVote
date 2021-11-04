import 'package:wevote/models/vote.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = auth.FirebaseAuth.instance;

class User extends ChangeNotifier {
  String fullName;
  String email;
  Map<String, Vote> participatedInVotes;
  Map<String, List<String>> userChoices;

  User(
      {String? fullName,
      required this.email,
      Map<String, Vote>? participatedInVotes,
      Map<String, List<String>>? userChoices})
      : participatedInVotes = participatedInVotes ?? {},
        userChoices = userChoices ?? {},
        fullName = fullName ?? '';

  User.empty()
      : email = '',
        fullName = '',
        participatedInVotes = {},
        userChoices = {};

  Future<bool> register(
      {required String email,
      required String password,
      required fullName}) async {
    try {
      // register
      auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      this.email = userCredential.user!.email!;
      // Sets the user displayName
      if (await updateUserName(fullName)) {
        this.fullName = fullName;
        // Create an empty record in user details collection for the new user, and return it's success status
        return await createUserDetailsDocument();
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
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Add the local userChoices to the database
  Future<bool> addVoteToUserData() async {
    try {
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
      // the document will be empty at the beginning
      Map<String, dynamic> emptyMap = {};
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
    Map<String, dynamic> temp = await userDetailsDocRef['userChoices'];
    // fromMap(<String, dynamic>{
    //   'NMwbr5G4DxFACsCzmh2J': ['one', 'two']
    // });
    // List<String> temp2 =
    //     (temp.values.toList()).map((e) => e as String).toList();
    // print(temp2);
    // Set the local userChoices
    userChoices = (temp).map(
      (k, e) =>
          MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
    );
    // userChoices = temp as Map<String, List<String>>;
    // userChoices = await userDetailsRef.get().then((snapshot) {
    //   var choices = snapshot.get('userChoices');
    //   return Map<String, List<String>>.from(choices);
    // });
    // Looping the userChoices and get the vote data for each vote the user is participating in:
    for (var voteId in userChoices.keys) {
      DocumentSnapshot vote = await votesRef.doc(voteId).get();
      Map<String, dynamic> voteData = vote.data() as Map<String, dynamic>;
      participatedInVotes[voteId] = Vote.fromJson(voteData);
    }
  }

  Future<void> submitChoices(String voteId, List<String> userSelections) async {
    // update local user choices
    userChoices[voteId] = userSelections;
    // update database user choices
    await addVoteToUserData();
  }

  // UnmodifiableListView<Vote> get votes {
  //   return UnmodifiableListView(participatedInVotes ?? []);
  // }
}

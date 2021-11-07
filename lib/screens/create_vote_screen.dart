import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wevote/models/current_vote_data/current_vote_data.dart';
import 'package:wevote/models/current_vote_data/current_vote_data_states.dart';
import 'package:wevote/models/user/user_states.dart';
import 'package:wevote/screens/add_choice_screen.dart';
import 'package:wevote/components/new_choices_list.dart';
import 'package:provider/provider.dart';
import 'package:wevote/models/user/user.dart';
import 'package:wevote/models/vote.dart';

class CreateVoteScreen extends StatefulWidget {
  static const String id = 'create_vote_screen';

  @override
  _CreateVoteScreenState createState() => _CreateVoteScreenState();
}

class _CreateVoteScreenState extends State<CreateVoteScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();
  // late Vote newVote;

  @override
  void initState() {
    super.initState();
    // newVote = Vote.emailOnly(Provider.of<User>(context, listen: false).email);
    // CurrentVoteData.get(context).currentVote =
    //     Vote.emailOnly(User.get(context).email);
    CurrentVoteData.get(context).resetVoteData(User.get(context).email);
    print('create vote screen init state');
    print('currentVote = ${CurrentVoteData.get(context).currentVote.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentVoteData, CurrentVoteDataStates>(
      listener: (context, currentVoteDataState) {},
      builder: (context, currentVoteDataState) {
        CurrentVoteData currentVoteData = CurrentVoteData.get(context);
        print('create vote screen build tree');
        // var newVote = currentVoteData.currentVote;
        return Scaffold(
          // Set resizeToAvoidBottomInset to false to prevent floatingActionButton from pushing up with the keyboard
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Create New Vote'),
          ),
          bottomNavigationBar: Padding(
            // TODO make the padding of the bottom bar constant
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 10.0,
            ),
            child: BottomAppBar(
              // TODO make the appbar transparent
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // TODO Make the flex value constant
                    flex: 9,
                    // TODO Replace depricated widget
                    child: BlocConsumer<User, UserStates>(
                      listener: (context, userState) {},
                      builder: (context, userState) {
                        var currentUser = User.get(context);
                        return RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0)),
                          child: Text('Create'),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_key.currentState!.validate()) {
                              currentVoteData.currentVote.title =
                                  _titleController.value.text;
                              currentVoteData.currentVote.description =
                                  _descriptionController.value.text;
                              currentUser.createVote(
                                  'tempId', currentVoteData.currentVote);
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    // TODO Make the flex value constant
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    // TODO Make the flex value constant
                    flex: 9,
                    // TODO Replace depricated widget
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0)),
                      child: Text('Cancel'),
                      onPressed: () {
                        // TODO Cancel the vote creating and return to the home screen
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add_box),
            backgroundColor: Colors.blue,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  // For certain screen sizes, this may mean the Add button is obscured. Setting the isScrolledControlled property to true you can make the modal take up the full screen:
                  isScrollControlled: true,
                  // To have the AddTaskScreen sit just above the keyboard, you can wrap it inside a SingleChildScrollView, which determines the padding at the bottom using a MediaQuery.
                  builder: (context) => SingleChildScrollView(
                          child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddChoiceScreen(),
                      )));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _titleController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      // The validator ensures the TextFormField isn’t empty.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _descriptionController,
                      // The validator ensures the TextFormField isn’t empty.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // public vote switch
                    SwitchListTile(
                      title: const Text('Public vote'),
                      value: currentVoteData.currentVote.isPublic,
                      onChanged: (value) {
                        currentVoteData.toggleIsPublic();
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Secret Identity'),
                      value: currentVoteData.currentVote.isSecretVote,
                      onChanged: (value) {
                        currentVoteData.toggleIsSecret();
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Allow participants to add choices'),
                      value: currentVoteData.currentVote.isAddingChoicesAllowed,
                      onChanged: (value) {
                        currentVoteData.toggleIsAddingChoicesAllowed();
                      },
                    ),
                    NewChoicesList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

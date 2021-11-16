abstract class CurrentVoteDataStates {}

class CurrentVoteInitialState extends CurrentVoteDataStates {}

class CurrentVoteOpenVoteDetailsState extends CurrentVoteDataStates {}

class CurrentVoteChangeUserSelectionState extends CurrentVoteDataStates {}

class CurrentVoteResetVoteDataState extends CurrentVoteDataStates {}

class CurrentVoteAddNewChoiceState extends CurrentVoteDataStates {}

class CurrentVoteChangeTitleState extends CurrentVoteDataStates {}

class CurrentVoteToggleIsPublicState extends CurrentVoteDataStates {}

class CurrentVoteToggleIsSecretState extends CurrentVoteDataStates {}

class CurrentVoteToggleIsAddingChoicesAllowedState
    extends CurrentVoteDataStates {}

class CurrentVoteEndVoteState extends CurrentVoteDataStates {}

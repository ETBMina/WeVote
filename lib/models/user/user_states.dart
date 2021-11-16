abstract class UserStates {}

class UserInitialState extends UserStates {}

class UserRegisteredState extends UserStates {}

class UserLoggedInState extends UserStates {}

class UserCreateVoteState extends UserStates {}

class UserUpdateDisplayNameState extends UserStates {}

class UserLoadParticipatedInVotesState extends UserStates {}

class UserSubmitChoicesState extends UserStates {}

class UserJoinVoteState extends UserStates {}

class UserDeleteVoteState extends UserStates {}

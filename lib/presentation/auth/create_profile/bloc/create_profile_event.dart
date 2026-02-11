import 'package:equatable/equatable.dart';

abstract class CreateProfileEvent extends Equatable {
  const CreateProfileEvent();

  @override
  List<Object?> get props => [];
}

class CreateProfileFirstNameChanged extends CreateProfileEvent {
  final String firstName;

  const CreateProfileFirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class CreateProfileUserNameChanged extends CreateProfileEvent {
  final String userName;

  const CreateProfileUserNameChanged(this.userName);

  @override
  List<Object?> get props => [userName];
}

class CreateProfileGenderChanged extends CreateProfileEvent {
  final String gender;

  const CreateProfileGenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class CreateProfileDobChanged extends CreateProfileEvent {
  final DateTime dob;

  const CreateProfileDobChanged(this.dob);

  @override
  List<Object?> get props => [dob];
}

class CreateProfileGenderSkipped extends CreateProfileEvent {
  const CreateProfileGenderSkipped();
}

class CreateProfileDobSkipped extends CreateProfileEvent {
  const CreateProfileDobSkipped();
}

class CreateProfileSubmitted extends CreateProfileEvent {
  const CreateProfileSubmitted();
}

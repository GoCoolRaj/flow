import 'package:equatable/equatable.dart';

enum CreateProfileStatus { idle, submitting, success }

class CreateProfileState extends Equatable {
  final String firstName;
  final String userName;
  final String gender;
  final DateTime? dob;
  final bool skippedGender;
  final bool skippedDob;
  final CreateProfileStatus status;

  const CreateProfileState({
    this.firstName = '',
    this.userName = '',
    this.gender = '',
    this.dob,
    this.skippedGender = false,
    this.skippedDob = false,
    this.status = CreateProfileStatus.idle,
  });

  bool get isNameStepValid =>
      firstName.trim().isNotEmpty && userName.trim().isNotEmpty;

  bool get isGenderStepValid =>
      gender.trim().isNotEmpty || skippedGender == true;

  bool get isDobStepValid => dob != null || skippedDob == true;

  CreateProfileState copyWith({
    String? firstName,
    String? userName,
    String? gender,
    DateTime? dob,
    bool? skippedGender,
    bool? skippedDob,
    CreateProfileStatus? status,
  }) {
    return CreateProfileState(
      firstName: firstName ?? this.firstName,
      userName: userName ?? this.userName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      skippedGender: skippedGender ?? this.skippedGender,
      skippedDob: skippedDob ?? this.skippedDob,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        userName,
        gender,
        dob,
        skippedGender,
        skippedDob,
        status,
      ];
}

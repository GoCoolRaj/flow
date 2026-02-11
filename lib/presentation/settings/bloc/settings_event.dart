import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsUserDetailsUpdated extends SettingsEvent {
  final UserDetailsData? userDetailsData;

  const SettingsUserDetailsUpdated(this.userDetailsData);

  @override
  List<Object?> get props => [userDetailsData];
}

class SaveNameRequested extends SettingsEvent {
  final String fullName;

  const SaveNameRequested(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class SaveUsernameRequested extends SettingsEvent {
  final String userName;

  const SaveUsernameRequested(this.userName);

  @override
  List<Object?> get props => [userName];
}

class SaveGenderRequested extends SettingsEvent {
  final String gender;

  const SaveGenderRequested(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SaveDobRequested extends SettingsEvent {
  final DateTime? dob;

  const SaveDobRequested(this.dob);

  @override
  List<Object?> get props => [dob];
}

class SaveProfilePhotoRequested extends SettingsEvent {
  final String filePath;

  const SaveProfilePhotoRequested(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ClearSettingsStatus extends SettingsEvent {
  const ClearSettingsStatus();
}

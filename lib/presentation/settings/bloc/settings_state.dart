import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';

enum SettingsStatus { idle, saving, saved, failure }

class SettingsState extends Equatable {
  final UserDetailsData? userDetailsData;
  final SettingsStatus status;

  const SettingsState({
    this.userDetailsData,
    this.status = SettingsStatus.idle,
  });

  SettingsState copyWith({
    UserDetailsData? userDetailsData,
    SettingsStatus? status,
  }) {
    return SettingsState(
      userDetailsData: userDetailsData ?? this.userDetailsData,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [userDetailsData, status];
}

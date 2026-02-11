import 'package:equatable/equatable.dart';

class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserId extends SessionEvent {
  final String userId;

  const UpdateUserId({required this.userId});
}

class LoadSessionUserDetails extends SessionEvent {}

class AddUserIdEntry extends SessionEvent {
  final String userId;
  final String userSessionId;

  const AddUserIdEntry({
    required this.userId,
    required this.userSessionId,
  });

  @override
  List<Object> get props => [userId, userSessionId];
}

class RemoveUserIdEntry extends SessionEvent {
  final String userId;
  final String userSessionId;

  const RemoveUserIdEntry({
    required this.userId,
    required this.userSessionId,
  });

  @override
  List<Object> get props => [userId, userSessionId];
}

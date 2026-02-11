import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';

class SessionState extends Equatable {
  final String userId;
  final UserDetailsData? userDetailsData;
  final Map<String, List<String>> userIdMap;

  const SessionState({
    this.userId = '',
    this.userDetailsData,
    this.userIdMap = const {},
  });

  SessionState copyWith({
    String? userId,
    UserDetailsData? userDetailsData,
    Map<String, List<String>>? userIdMap,
  }) {
    return SessionState(
      userId: userId ?? this.userId,
      userDetailsData: userDetailsData ?? this.userDetailsData,
      userIdMap: userIdMap ?? this.userIdMap,
    );
  }

  @override
  List<Object?> get props => [userId, userDetailsData, userIdMap];
}

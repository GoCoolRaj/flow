import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';
import 'package:quilt_flow_app/domain/session/use_cases/get_session_user_details_usecase.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_event.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_state.dart';

class SessionBloc extends BaseBloc<SessionEvent, SessionState> {
  late final _getUserDetailsUseCase = getIt.get<GetSessionUserDetailsUsecase>();
  late final String userId;

  SessionBloc() : super(const SessionState()) {
    on<UpdateUserId>(_updateUserId);
    on<LoadSessionUserDetails>(_loadUserDetails);
    on<AddUserIdEntry>(_addUserIdEntry);
    on<RemoveUserIdEntry>(_removeUserIdEntry);

    userId = getIt<HiveManager>().getFromHive(HiveManager.userIdKey) ?? "";

    add(UpdateUserId(userId: userId));
    if (userId.isNotEmpty) {
      add(LoadSessionUserDetails());
    }
  }

  void _updateUserId(UpdateUserId event, Emitter<SessionState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  Future<void> _loadUserDetails(
    LoadSessionUserDetails event,
    Emitter<SessionState> emit,
  ) async {
    final response = await safeExecute<UserDetailsData>(
      function: () => _getUserDetailsUseCase.execute(request: userId),
      showLoading: false,
      showError: false,
    );
    if (response != null) {
      emit(state.copyWith(userDetailsData: response));
    }
  }

  void _addUserIdEntry(AddUserIdEntry event, Emitter<SessionState> emit) {
    final updatedMap = Map<String, List<String>>.from(state.userIdMap);
    final existingList = List<String>.from(
      updatedMap[event.userId] ?? const [],
    );
    if (!existingList.contains(event.userSessionId)) {
      existingList.add(event.userSessionId);
    }
    updatedMap[event.userId] = existingList;
    emit(state.copyWith(userIdMap: updatedMap));
  }

  void _removeUserIdEntry(RemoveUserIdEntry event, Emitter<SessionState> emit) {
    final updatedMap = SessionBloc.removeUserIdFromMap(
      state.userIdMap,
      event.userId,
    );
    emit(state.copyWith(userIdMap: updatedMap));
  }

  static String generateIncrementedUserId(
    Map<String, List<String>> userIdMap,
    String userId,
  ) {
    final existing = List<String>.from(userIdMap[userId] ?? const []);
    int nextIndex = 1;
    if (existing.isNotEmpty) {
      final last = existing.last;
      final dash = last.lastIndexOf('-');
      final lastIdx = (dash != -1)
          ? int.tryParse(last.substring(dash + 1))
          : null;
      nextIndex = (lastIdx ?? existing.length) + 1;
    }
    return '$userId-$nextIndex';
  }

  static Map<String, List<String>> removeUserIdFromMap(
    Map<String, List<String>> originalMap,
    String userId,
  ) {
    final updatedMap = Map<String, List<String>>.from(originalMap);
    final existing = List<String>.from(updatedMap[userId] ?? const []);
    if (existing.isEmpty) return updatedMap;
    existing.removeLast();
    if (existing.isEmpty) {
      updatedMap.remove(userId);
    } else {
      updatedMap[userId] = existing;
    }
    return updatedMap;
  }
}

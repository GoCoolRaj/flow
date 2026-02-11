import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/create_profile/use_cases/create_profile_use_cases.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_bloc.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_event.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_state.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_event.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';

class SettingsBloc extends BaseBloc<SettingsEvent, SettingsState> {
  late final SessionBloc _sessionBloc = getIt.get<SessionBloc>();
  late final _createProfileUseCases = getIt.get<CreateProfileUseCases>();
  late final _hiveManager = getIt.get<HiveManager>();
  StreamSubscription<SessionState>? _sessionSubscription;

  SettingsBloc() : super(const SettingsState()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsUserDetailsUpdated>(_onUserDetailsUpdated);
    on<SaveNameRequested>(_onSaveNameRequested);
    on<SaveUsernameRequested>(_onSaveUsernameRequested);
    on<SaveGenderRequested>(_onSaveGenderRequested);
    on<SaveDobRequested>(_onSaveDobRequested);
    on<SaveProfilePhotoRequested>(_onSaveProfilePhotoRequested);
    on<ClearSettingsStatus>(_onClearStatus);

    _sessionSubscription = _sessionBloc.stream.listen((sessionState) {
      add(SettingsUserDetailsUpdated(sessionState.userDetailsData));
    });

    add(const SettingsStarted());
  }

  void _onStarted(SettingsStarted event, Emitter<SettingsState> emit) {
    final existing = _sessionBloc.state.userDetailsData;
    emit(state.copyWith(userDetailsData: existing));
    if (existing == null) {
      _sessionBloc.add(LoadSessionUserDetails());
    }
  }

  void _onUserDetailsUpdated(
    SettingsUserDetailsUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(userDetailsData: event.userDetailsData));
  }

  Future<void> _onSaveNameRequested(
    SaveNameRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _submitProfileUpdate(emit, fullName: event.fullName);
  }

  Future<void> _onSaveUsernameRequested(
    SaveUsernameRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _submitProfileUpdate(emit, userName: event.userName);
  }

  Future<void> _onSaveGenderRequested(
    SaveGenderRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _submitProfileUpdate(emit, gender: event.gender);
  }

  Future<void> _onSaveDobRequested(
    SaveDobRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _submitProfileUpdate(emit, dob: event.dob);
  }

  Future<void> _onSaveProfilePhotoRequested(
    SaveProfilePhotoRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final bytes = await File(event.filePath).readAsBytes();
    final encoded = base64Encode(bytes);
    await _submitProfileUpdate(
      emit,
      profilePicture: encoded,
      profilePicturePath: event.filePath,
    );
  }

  void _onClearStatus(ClearSettingsStatus event, Emitter<SettingsState> emit) {
    emit(state.copyWith(status: SettingsStatus.idle));
  }

  Future<void> _submitProfileUpdate(
    Emitter<SettingsState> emit, {
    String? fullName,
    String? userName,
    String? gender,
    DateTime? dob,
    String? profilePicture,
    String? profilePicturePath,
  }) async {
    final userId = _hiveManager.getFromHive<String>(HiveManager.userIdKey);
    if (userId == null || userId.trim().isEmpty) {
      await showErrorMsg('Missing user session. Please login again.');
      return;
    }

    final current = state.userDetailsData ?? _sessionBloc.state.userDetailsData;
    final resolvedFirstName = (fullName ?? current?.firstName ?? '').trim();
    final resolvedUserName = (userName ?? current?.userName ?? '').trim();
    final resolvedGender = (gender ?? current?.gender ?? '').trim().isEmpty
        ? 'Other'
        : (gender ?? current?.gender ?? '').trim();

    DateTime? resolvedDob;
    if (dob != null) {
      resolvedDob = dob;
    } else if (current?.dob.isNotEmpty == true) {
      resolvedDob = DateTime.tryParse(current!.dob);
    }

    final dobFormatted = resolvedDob != null
        ? DateFormat('yyyy-MM-dd').format(resolvedDob)
        : null;
    final age = resolvedDob != null ? _calculateAge(resolvedDob) : 0;

    emit(state.copyWith(status: SettingsStatus.saving));

    final response = await safeExecute(
      function: () async {
        return _createProfileUseCases.execute(
          request: CreateProfileRequest(
            userId: userId,
            isDeleted: false,
            firstName: resolvedFirstName,
            userName: resolvedUserName,
            gender: resolvedGender,
            timeZone: DateTime.now().timeZoneName,
            age: age,
            dob: dobFormatted,
            profilePicture: profilePicture,
          ),
        );
      },
      showLoading: true,
      showError: false,
    );

    if (response == null) {
      emit(state.copyWith(status: SettingsStatus.failure));
      return;
    }

    await _hiveManager.saveToHive(HiveManager.firstName, resolvedFirstName);
    await _hiveManager.saveToHive(HiveManager.userName, resolvedUserName);

    final updatedFirstName = resolvedFirstName;
    final updatedLastName = current?.lastName ?? '';

    final updatedUser =
        (current ??
                _sessionBloc.state.userDetailsData ??
                UserDetailsData(
                  firstName: '',
                  lastName: '',
                  email: '',
                  phoneNumber: '',
                  countryCode: '',
                  profilePicture: '',
                  gender: '',
                  age: 0,
                  dob: '',
                  timeZone: '',
                  notification: '',
                  userName: '',
                  fabricId: '',
                  fabricUrl: '',
                  unsavedProfilePicture: '',
                ))
            .copyWith(
              firstName: updatedFirstName,
              lastName: updatedLastName,
              userName: resolvedUserName,
              gender: resolvedGender,
              dob: dobFormatted ?? '',
              age: age,
              timeZone: DateTime.now().timeZoneName,
              profilePicture:
                  profilePicturePath ?? (current?.profilePicture ?? ''),
            );

    emit(
      state.copyWith(
        userDetailsData: updatedUser,
        status: SettingsStatus.saved,
      ),
    );

    _sessionBloc.add(LoadSessionUserDetails());
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    final hasHadBirthdayThisYear =
        (now.month > dob.month) ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hasHadBirthdayThisYear) {
      age -= 1;
    }
    return age;
  }

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    return super.close();
  }
}

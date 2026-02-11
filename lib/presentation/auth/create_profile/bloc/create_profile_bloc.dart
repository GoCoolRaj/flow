import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/create_profile/use_cases/create_profile_use_cases.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_event.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_state.dart';

class CreateProfileBloc
    extends BaseBloc<CreateProfileEvent, CreateProfileState> {
  late final _createProfileUseCases = getIt.get<CreateProfileUseCases>();
  late final _hiveManager = getIt.get<HiveManager>();

  CreateProfileBloc() : super(const CreateProfileState()) {
    on<CreateProfileFirstNameChanged>(_onFirstNameChanged);
    on<CreateProfileUserNameChanged>(_onUserNameChanged);
    on<CreateProfileGenderChanged>(_onGenderChanged);
    on<CreateProfileDobChanged>(_onDobChanged);
    on<CreateProfileGenderSkipped>(_onGenderSkipped);
    on<CreateProfileDobSkipped>(_onDobSkipped);
    on<CreateProfileSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onFirstNameChanged(
    CreateProfileFirstNameChanged event,
    Emitter<CreateProfileState> emit,
  ) {
    emit(state.copyWith(firstName: event.firstName));
  }

  FutureOr<void> _onUserNameChanged(
    CreateProfileUserNameChanged event,
    Emitter<CreateProfileState> emit,
  ) {
    emit(state.copyWith(userName: event.userName));
  }

  FutureOr<void> _onGenderChanged(
    CreateProfileGenderChanged event,
    Emitter<CreateProfileState> emit,
  ) {
    emit(
      state.copyWith(
        gender: event.gender,
        skippedGender: false,
      ),
    );
  }

  FutureOr<void> _onDobChanged(
    CreateProfileDobChanged event,
    Emitter<CreateProfileState> emit,
  ) {
    emit(
      state.copyWith(
        dob: event.dob,
        skippedDob: false,
      ),
    );
  }

  FutureOr<void> _onGenderSkipped(
    CreateProfileGenderSkipped event,
    Emitter<CreateProfileState> emit,
  ) {
    emit(
      state.copyWith(
        gender: '',
        skippedGender: true,
      ),
    );
  }

  FutureOr<void> _onDobSkipped(
    CreateProfileDobSkipped event,
    Emitter<CreateProfileState> emit,
  ) {
    emit(
      state.copyWith(
        dob: null,
        skippedDob: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateProfileSubmitted event,
    Emitter<CreateProfileState> emit,
  ) async {
    if (!state.isNameStepValid ||
        !state.isGenderStepValid ||
        !state.isDobStepValid) {
      await showErrorMsg('Please complete all steps to continue.');
      return;
    }

    final userId = _hiveManager.getFromHive<String>(HiveManager.userIdKey);
    if (userId == null || userId.isEmpty) {
      await showErrorMsg('Missing user session. Please login again.');
      return;
    }

    final bool hasDob = state.dob != null;
    final dobFormatted =
        hasDob ? DateFormat('yyyy-MM-dd').format(state.dob!) : null;
    final age = hasDob ? _calculateAge(state.dob!) : 0;
    final gender = state.gender.isNotEmpty ? state.gender : 'Other';

    emit(state.copyWith(status: CreateProfileStatus.submitting));

    final response = await safeExecute(
      function: () async {
        return _createProfileUseCases.execute(
          request: CreateProfileRequest(
            userId: userId,
            isDeleted: false,
            firstName: state.firstName.trim(),
            userName: state.userName.trim(),
            gender: gender,
            timeZone: DateTime.now().timeZoneName,
            age: age,
            dob: dobFormatted,
          ),
        );
      },
      showLoading: true,
      showError: true,
    );

    if (response == null) {
      emit(state.copyWith(status: CreateProfileStatus.idle));
      return;
    }

    await _hiveManager.saveToHive(HiveManager.firstName, state.firstName);
    await _hiveManager.saveToHive(HiveManager.userName, state.userName);
    await _hiveManager.saveToHive(HiveManager.userProfileUpdated, true);

    emit(state.copyWith(status: CreateProfileStatus.success));
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
}

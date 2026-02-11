import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/create_profile/create_profile_repository.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';

class CreateProfileUseCases
    implements BaseUseCase<CreateProfileRequest, CreateProfileResponse> {
  final _createProfileRepository = GetIt.I<CreateProfileRepository>();

  @override
  Future<CreateProfileResponse> execute({CreateProfileRequest? request}) {
    return _createProfileRepository.createProfile(request!);
  }
}

class CreateProfileRequest {
  final String userId;
  final String firstName;
  final String userName;
  final String gender;
  final String timeZone;
  final int age;
  final String? dob;
  final String? profilePicture;
  final bool isDeleted;

  CreateProfileRequest({
    required this.userId,
    required this.isDeleted,
    required this.firstName,
    required this.userName,
    required this.gender,
    required this.timeZone,
    required this.age,
    required this.dob,
    this.profilePicture,
  });
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'isDeleted': isDeleted,
      'firstName': firstName,
      'userName': userName,
      'gender': gender,
      'timeZone': timeZone,
      'age': age,
      'dob': dob,
      'profilePicture': profilePicture,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  String toJson() => json.encode(toMap());
}

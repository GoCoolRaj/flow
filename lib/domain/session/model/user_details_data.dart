class UserDetailsData {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String countryCode;
  String profilePicture;
  String gender;
  int age;
  String dob;
  String timeZone;
  String notification;
  String userName;
  String fabricId;
  String fabricUrl;
  String unsavedProfilePicture;

  UserDetailsData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.profilePicture,
    required this.gender,
    required this.age,
    required this.dob,
    required this.timeZone,
    required this.notification,
    required this.userName,
    required this.fabricId,
    required this.fabricUrl,
    required this.unsavedProfilePicture,
  });

  UserDetailsData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? profilePicture,
    String? gender,
    int? age,
    String? dob,
    String? timeZone,
    String? notification,
    String? userName,
    String? fabricId,
    String? fabricUrl,
    String? unsavedProfilePicture,
  }) {
    return UserDetailsData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      profilePicture: profilePicture ?? this.profilePicture,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      dob: dob ?? this.dob,
      timeZone: timeZone ?? this.timeZone,
      notification: notification ?? this.notification,
      userName: userName ?? this.userName,
      fabricId: fabricId ?? this.fabricId,
      fabricUrl: fabricUrl ?? this.fabricUrl,
      unsavedProfilePicture:
          unsavedProfilePicture ?? this.unsavedProfilePicture,
    );
  }

  factory UserDetailsData.fromJson(Map<String, dynamic> json) {
    return UserDetailsData(
        firstName: json['firstName'] ?? "",
        lastName: json['lastName'] ?? "",
        userName: json['userName'] ?? "",
        email: json['email'] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        countryCode: json["countryCode"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
        gender: json["gender"] ?? "",
        age: json["age"] ?? -1,
        dob: json["DOB"] ?? "",
        notification: json["notification"] ?? "",
        fabricId: json["fabricId"] ?? "",
        unsavedProfilePicture: json["unsavedProfilePicture"] ?? "",
        fabricUrl: json["fabricUrl"] ?? "",
        timeZone: json["timeZone"] ?? "");
  }
}

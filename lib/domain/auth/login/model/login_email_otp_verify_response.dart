class LoginEmailOtpVerifyResponse {
  String sessionToken;
  String appSessionId;
  String sessionStatus;
  String userId;
  bool isFirstLogin;
  dynamic firstName;
  dynamic lastName;
  dynamic dob;
  dynamic gender;
  dynamic phoneNumber;
  dynamic countryCode;
  String email;
  dynamic ethnicity;
  String? origin;
  String userName;
  bool isUserProfileUpdated;
  bool hasAtleastOnePrivateFlag;

  LoginEmailOtpVerifyResponse({
    required this.sessionToken,
    required this.appSessionId,
    required this.sessionStatus,
    required this.userId,
    required this.isFirstLogin,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
    required this.countryCode,
    required this.email,
    required this.ethnicity,
    required this.origin,
    required this.isUserProfileUpdated,
    required this.hasAtleastOnePrivateFlag,
    required this.userName,
  });

  factory LoginEmailOtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      LoginEmailOtpVerifyResponse(
        sessionToken: json["sessionToken"],
        appSessionId: json["appSessionId"],
        sessionStatus: json["sessionStatus"],
        userId: json["userId"],
        isFirstLogin: json["isFirstLogin"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"],
        gender: json["gender"],
        phoneNumber: json["phoneNumber"],
        countryCode: json["countryCode"],
        email: json["email"],
        ethnicity: json["ethnicity"],
        origin: json["origin"]?.toString(),
        isUserProfileUpdated: json["isUserProfileUpdated"],
        userName: json["userName"] ?? "",
        hasAtleastOnePrivateFlag: json["hasAtleastOnePrivateFlag"] ?? true,
      );

  Map<String, dynamic> toJson() => {
    "sessionToken": sessionToken,
    "appSessionId": appSessionId,
    "sessionStatus": sessionStatus,
    "userId": userId,
    "isFirstLogin": isFirstLogin,
    "firstName": firstName,
    "lastName": lastName,
    "dob": dob,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "countryCode": countryCode,
    "email": email,
    "ethnicity": ethnicity,
    "origin": origin,
    "isUserProfileUpdated": isUserProfileUpdated,
    "hasAtleastOnePrivateFlag": hasAtleastOnePrivateFlag,
  };
}

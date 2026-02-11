class CreateProfileResponse {
  String message;
  int statusCode;
  int errorCode;

  CreateProfileResponse(
      {required this.message,
      required this.statusCode,
      required this.errorCode});

  factory CreateProfileResponse.fromJson(Map<String, dynamic> json) {
    return CreateProfileResponse(
        message: json['message'].toString(),
        statusCode: json['status'] ?? 0,
        errorCode: json["errorCode"] ?? 0);
  }
}

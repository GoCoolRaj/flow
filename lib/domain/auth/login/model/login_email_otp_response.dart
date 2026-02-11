class LoginEmailOtpResponse {
  int status;
  String message;

  LoginEmailOtpResponse({
    required this.status,
    required this.message,
  });

  factory LoginEmailOtpResponse.fromJsonList(List<dynamic> json) {
    return LoginEmailOtpResponse.fromJson(json.first);
  }

  factory LoginEmailOtpResponse.fromJson(Map<String, dynamic> json) =>
      LoginEmailOtpResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}

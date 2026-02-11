class VerifyInviteCodeResponse {
  final String email;
  final String? message;
  final int? status;

  VerifyInviteCodeResponse({
    required this.email,
    this.message,
    this.status,
  });

  factory VerifyInviteCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyInviteCodeResponse(
      email: (json['email'] ?? json['emailId'] ?? '').toString(),
      message: json['message']?.toString(),
      status: json['status'] as int?,
    );
  }
}

class FollowUnfollowResponse {
  final int status;
  final String message;

  FollowUnfollowResponse({
    required this.status,
    required this.message,
  });

  factory FollowUnfollowResponse.fromJson(Map<String, dynamic> json) {
    return FollowUnfollowResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

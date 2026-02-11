class FollowUnfollowRequest {
  final String userId;

  const FollowUnfollowRequest({
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}

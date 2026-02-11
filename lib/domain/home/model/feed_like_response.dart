class FeedLikeResponse {
  String message;
  int errorCode;
  String userId;
  String contentId;
  int likesCount;

  FeedLikeResponse(
      {required this.message,
      required this.errorCode,
      required this.likesCount,
      required this.userId,
      required this.contentId});

  factory FeedLikeResponse.fromJson(Map<String, dynamic> json) {
    return FeedLikeResponse(
        userId: json['userId'],
        likesCount: json["likesCount"],
        contentId: json["contentId"],
        message: "",
        errorCode: 200);
  }
}

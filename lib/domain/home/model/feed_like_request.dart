import 'dart:convert';

class FeedLikeRequest {
  String? userId;
  String? contentId;

  FeedLikeRequest({
    this.userId,
    required this.contentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'contentId': contentId,
    };
  }

  String toJson() => json.encode(toMap());
}

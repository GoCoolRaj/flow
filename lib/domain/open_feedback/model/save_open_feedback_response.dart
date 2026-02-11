class SaveOpenFeedbackResponse {
  String? feedbackId;
  String? overallFeedback;
  String? userId;
  int? rating;
  SaveOpenFeedbackResponse({
    required this.feedbackId,
    required this.userId,
    required this.overallFeedback,
    required this.rating,
  });
  factory SaveOpenFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return SaveOpenFeedbackResponse(
      feedbackId: json['userOverallFeedbackResponseId'] ?? "",
      userId: json['userId'] ?? "",
      overallFeedback: json['overallFeedback'] ?? "",
      rating: json['rating'] ?? 0,
    );
  }
}

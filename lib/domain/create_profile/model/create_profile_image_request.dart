class CreateProfileImageRequest {
  final String prompt;
  final String fabricId;
  final String fabricUrl;
  final String userId;

  CreateProfileImageRequest({
    required this.prompt,
    required this.fabricId,
    required this.fabricUrl,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'fabricId': fabricId,
      'userId': userId,
      'fabricUrl': fabricUrl,
    };
  }
}

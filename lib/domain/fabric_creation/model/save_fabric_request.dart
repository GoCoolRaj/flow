class SaveFabricRequest {
  final String userId;
  final String fabricId;
  final String fabricName;
  final bool? isPublic;
  final String imageUrl;

  SaveFabricRequest({
    required this.userId,
    required this.fabricId,
    required this.fabricName,
    this.isPublic = false,
    required this.imageUrl,
  });

  factory SaveFabricRequest.fromJson(Map<String, dynamic> json) {
    return SaveFabricRequest(
      userId: json['userId'] as String,
      fabricId: json['fabricId'] as String,
      fabricName: json['fabricName'] as String,
      isPublic: json['isPublic'] as bool,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fabricId': fabricId,
      'fabricName': fabricName,
      'isPublic': isPublic,
      'imageUrl': imageUrl,
    };
  }
}

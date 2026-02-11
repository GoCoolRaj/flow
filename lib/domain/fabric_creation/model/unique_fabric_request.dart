class UniqueFabricRequest {
  final String userId;
  final String fabricName;

  UniqueFabricRequest({
    required this.userId,
    required this.fabricName,
  });

  factory UniqueFabricRequest.fromJson(Map<String, dynamic> json) {
    return UniqueFabricRequest(
      userId: json['userId'] as String,
      fabricName: json['fabricName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fabricName': fabricName,
    };
  }
}

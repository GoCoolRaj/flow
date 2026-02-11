class CreateCollectionResponse {
  String? collectionId;
  String? collectionName;
  int? statusCode;
  String? message;
  CreateCollectionResponse({
    required this.collectionId,
    required this.collectionName,
    required this.statusCode,
    required this.message,
  });
  factory CreateCollectionResponse.fromJson(Map<String, dynamic> json) {
    return CreateCollectionResponse(
      collectionId: json['collectionId'],
      statusCode: json['status'] ?? 0,
      message: json['message'] ?? "",
      collectionName: json['collectionName'],
    );
  }
}

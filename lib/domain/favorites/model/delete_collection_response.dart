class DeleteCollectionResponse {
  String message;
  int statusCode;

  DeleteCollectionResponse({required this.message, required this.statusCode});

  factory DeleteCollectionResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCollectionResponse(
        message: json['message'].toString(), statusCode: json['status']);
  }
}

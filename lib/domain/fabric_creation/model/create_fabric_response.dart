enum FabricStatus { SUCCESS, FAILED }

class CreateFabricResponse {
  final FabricStatus status;
  final String message;
  final String fabricId;
  final String comments;
  final String imageId;
  final int errorCode;

  CreateFabricResponse({
    required this.status,
    required this.message,
    required this.fabricId,
    required this.comments,
    required this.imageId,
    required this.errorCode,
  });

  factory CreateFabricResponse.fromJson(Map<String, dynamic> json) {
    return CreateFabricResponse(
      status: json['status'] == 'SUCCESS'
          ? FabricStatus.SUCCESS
          : FabricStatus.FAILED,
      message: json['message'] ?? "",
      fabricId: json['fabricId'] ?? "",
      comments: json['comments'] ?? "",
      imageId: json['image_id'] ?? "",
      errorCode: json['errorCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status == FabricStatus.SUCCESS ? 'SUCCESS' : 'FAILED',
      'message': message,
      'fabricId': fabricId,
      'comments': comments,
      'image_id': imageId,
    };
  }
}

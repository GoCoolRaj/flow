enum SaveFabricStatus { SUCCESS, FAILED }

class SaveFabricResponse {
  final SaveFabricStatus status;
  final String message;
  final String fabricId;

  SaveFabricResponse({
    required this.status,
    required this.message,
    required this.fabricId,
  });

  factory SaveFabricResponse.fromJson(Map<String, dynamic> json) {
    return SaveFabricResponse(
      status: json['status'] == 'SUCCESS'
          ? SaveFabricStatus.SUCCESS
          : SaveFabricStatus.FAILED,
      message: json['message'] as String,
      fabricId: json['fabricId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status == SaveFabricStatus.SUCCESS ? 'SUCCESS' : 'FAILED',
      'message': message,
      'fabricId': fabricId,
    };
  }
}

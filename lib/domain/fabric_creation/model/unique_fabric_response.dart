class UniqueFabricResponse {
  final int status;
  final int errorCode;
  final String message;
  final bool isUnique;
  final bool isSafe;

  UniqueFabricResponse({
    required this.status,
    required this.message,
    required this.isUnique,
    this.isSafe = true,
    this.errorCode = 0,
  });

  factory UniqueFabricResponse.fromJson(Map<String, dynamic> json) {
    return UniqueFabricResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      isUnique: json['isUnique'] ?? false,
      isSafe: json['isSafe'] ?? true,
      errorCode: json['errorCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'isUnique': isUnique,
      'isSafe': isSafe,
    };
  }
}

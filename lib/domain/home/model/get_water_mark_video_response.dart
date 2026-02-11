class GetWaterMarkVideoResponse {
  String watermarkStatus;
  String watermarkedUrl;

  GetWaterMarkVideoResponse(
      {required this.watermarkStatus, required this.watermarkedUrl});

  factory GetWaterMarkVideoResponse.fromJson(Map<String, dynamic> json) {
    return GetWaterMarkVideoResponse(
      watermarkStatus: json['watermarkStatus'] ?? "",
      watermarkedUrl: json["watermarkedUrl"] ?? "",
    );
  }
}

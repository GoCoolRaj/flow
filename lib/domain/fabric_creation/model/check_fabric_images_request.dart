class CheckFabricImagesRequest {
  final String fabricId;

  CheckFabricImagesRequest({
    required this.fabricId,
  });

  Map<String, dynamic> toJson() {
    return {
      'fabricId': fabricId,
    };
  }
}

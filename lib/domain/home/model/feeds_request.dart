class FeedsRequest {
  final String? name;
  final String? contentType;
  final String? moodName;
  final String? hashtagName;
  final bool? isSurpriseMe;
  final String? moodClusterId;
  final String userId;
  final int? page;
  final int? pageSize;
  final String? authorizationToken;
  final String? fabricId;
  final String? assetType;

  FeedsRequest({
    this.name,
    this.contentType,
    this.moodName,
    this.hashtagName,
    this.isSurpriseMe,
    this.moodClusterId,
    required this.userId,
    this.page,
    this.pageSize,
    this.authorizationToken,
    this.fabricId,
    this.assetType,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fabricId': fabricId,
      'assetType': assetType,
      'page': page,
      'limit': pageSize,
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'FeedsRequest(moodName: $moodName,  hashtagName: $hashtagName, isSurpriseMe: $isSurpriseMe, moodClusterId: $moodClusterId, userId: $userId, page: $page, pageSize: $pageSize, fabricId: $fabricId)';
  }
}

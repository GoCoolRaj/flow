import 'package:quilt_flow_app/domain/home/model/content_flavours.dart';

class ContentFeedResponse {
  final int? totalItems;
  final int? nextPage;
  final bool? isLast;
  final bool? isUserTimeZoneSet;
  final List<ContentItem> data;

  ContentFeedResponse({
    this.totalItems,
    this.nextPage,
    this.isLast,
    this.isUserTimeZoneSet,
    List<ContentItem>? data,
  }) : data = data ?? const [];

  factory ContentFeedResponse.fromJson(Map<String, dynamic> json) {
    return ContentFeedResponse(
      totalItems: json["totalItems"],
      nextPage: json["nextPage"],
      isLast: json["isLast"],
      isUserTimeZoneSet: json["isUserTimeZoneSet"],
      data: json["data"] != null ? ContentItem.fromJsonList(json["data"]) : [],
    );
  }
}

class ContentItem {
  final String? userId;
  final Content content;

  ContentItem({this.userId, Content? content})
    : content = content ?? Content.empty();

  ContentItem copyWith({String? userId, Content? content}) {
    return ContentItem(
      userId: userId ?? this.userId,
      content: content ?? this.content,
    );
  }

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final nested =
        json['content'] as Map<String, dynamic>? ??
        json['contentDetails'] as Map<String, dynamic>?;
    final Map<String, dynamic> contentJson = nested ?? json;
    return ContentItem(
      userId: (json['userId'] as String?) ??
          (nested != null ? nested['userId'] as String? : null),
      content: Content.fromJson(contentJson),
    );
  }

  static List<ContentItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => ContentItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class Content {
  final String id;
  final ContentType contentType;
  final ContentFormat contentFormat;
  final String contentGenerationStatus;
  final bool isDeleted;
  final String deletedBy;
  final int contentDuration;
  final String externalReference;
  final bool toRecommend;
  final String description;
  final String prompt;
  final String contentName;
  final String contentUrl;
  final String thumbnailUrl;
  final bool isLike;
  final bool isFavourite;
  final int likeCount;
  final double finalBoost;
  final double recencyBoost;
  final String watermarkedUrl;
  final String watermarkStatus;
  final String weblink;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AssociatedFabric> associatedFabrics;
  final int totalComments;
  final String firstName;
  final String userName;
  final String profilePicture;
  final String collectionId;
  final bool isFollowed;
  final List<MediaItem> media;
  final UserDetails userDetails;
  final bool wasLikedBefore;

  Content({
    required this.id,
    this.contentType = ContentType.INITIAL,
    this.contentFormat = ContentFormat.INITIAL,
    this.contentGenerationStatus = '',
    this.isDeleted = false,
    this.deletedBy = '',
    this.contentDuration = 0,
    this.externalReference = '',
    this.toRecommend = false,
    this.description = '',
    this.prompt = '',
    this.contentName = '',
    this.contentUrl = '',
    this.thumbnailUrl = '',
    this.isLike = false,
    this.isFavourite = false,
    this.likeCount = 0,
    this.finalBoost = 0.0,
    this.recencyBoost = 0.0,
    this.watermarkedUrl = '',
    this.watermarkStatus = '',
    this.weblink = '',
    this.createdAt,
    this.updatedAt,
    this.associatedFabrics = const [],
    this.totalComments = 0,
    this.firstName = '',
    this.userName = '',
    this.profilePicture = '',
    this.collectionId = '',
    this.isFollowed = false,
    this.media = const [],
    this.userDetails = const UserDetails(),
    this.wasLikedBefore = false,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as String? ?? '',
      contentType:
          parseContentType(json['contentType'] as String? ?? '') ??
          ContentType.INITIAL,
      contentFormat:
          parseContentFormat(json['contentFormat'] as String? ?? '') ??
          ContentFormat.INITIAL,
      contentGenerationStatus: json['contentGenerationStatus'] as String? ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedBy: json['deletedBy']?.toString() ?? '',
      contentDuration: json['contentDuration'] as int? ?? 0,
      externalReference: json['externalReference'] as String? ?? '',
      toRecommend: json['toRecommend'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      prompt: json['prompt']?.toString() ?? '',
      contentName: json['contentName'] as String? ?? '',
      contentUrl: json['contentUrl']?.toString() ?? '',
      thumbnailUrl: json['contentThumbnail'] as String? ?? '',
      isLike: json['isLike'] as bool? ?? false,
      isFavourite: json['isFavourite'] as bool? ?? false,
      likeCount: json['likesCount'] as int? ?? 0,
      finalBoost: (json['finalBoost'] as num?)?.toDouble() ?? 0.0,
      recencyBoost: (json['recencyBoost'] as num?)?.toDouble() ?? 0.0,
      watermarkedUrl: json['watermarkedUrl']?.toString() ?? '',
      watermarkStatus: json['watermarkStatus']?.toString() ?? '',
      weblink: json['weblink']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      associatedFabrics:
          (json['associatedFabrics'] as List<dynamic>?)
              ?.map((e) => AssociatedFabric.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalComments: json['totalComments'] as int? ?? 0,
      firstName: json['firstName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      profilePicture: json['profilePicture'] as String? ?? '',
      collectionId: json['collectionId'] as String? ?? '',
      isFollowed: json['isFollowed'] as bool? ?? false,
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userDetails: json['userDetails'] != null
          ? UserDetails.fromJson(json['userDetails'] as Map<String, dynamic>)
          : const UserDetails(),
    );
  }

  static ContentType? parseContentType(String contentType) {
    return ContentType.values.firstWhere(
      (e) => e.toString().split('.').last == contentType,
      orElse: () => ContentType.INITIAL,
    );
  }

  static ContentFormat? parseContentFormat(String contentFormat) {
    return ContentFormat.values.firstWhere(
      (e) => e.toString().split('.').last == contentFormat,
      orElse: () => ContentFormat.INITIAL,
    );
  }

  Content copyWith({
    String? id,
    ContentType? contentType,
    ContentFormat? contentFormat,
    String? contentGenerationStatus,
    bool? isDeleted,
    String? deletedBy,
    int? contentDuration,
    String? externalReference,
    bool? toRecommend,
    String? description,
    String? prompt,
    String? contentName,
    String? contentUrl,
    String? thumbnailUrl,
    bool? isLike,
    bool? isFavourite,
    int? likeCount,
    double? finalBoost,
    double? recencyBoost,
    String? watermarkedUrl,
    String? watermarkStatus,
    String? weblink,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AssociatedFabric>? associatedFabrics,
    int? totalComments,
    String? firstName,
    String? userName,
    String? profilePicture,
    String? collectionId,
    bool? isFollowed,
    List<MediaItem>? media,
    UserDetails? userDetails,
    bool? wasLikedBefore,
  }) {
    return Content(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      contentFormat: contentFormat ?? this.contentFormat,
      contentGenerationStatus:
          contentGenerationStatus ?? this.contentGenerationStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedBy: deletedBy ?? this.deletedBy,
      contentDuration: contentDuration ?? this.contentDuration,
      externalReference: externalReference ?? this.externalReference,
      toRecommend: toRecommend ?? this.toRecommend,
      description: description ?? this.description,
      prompt: prompt ?? this.prompt,
      contentName: contentName ?? this.contentName,
      contentUrl: contentUrl ?? this.contentUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isLike: isLike ?? this.isLike,
      isFavourite: isFavourite ?? this.isFavourite,
      likeCount: likeCount ?? this.likeCount,
      finalBoost: finalBoost ?? this.finalBoost,
      recencyBoost: recencyBoost ?? this.recencyBoost,
      watermarkedUrl: watermarkedUrl ?? this.watermarkedUrl,
      watermarkStatus: watermarkStatus ?? this.watermarkStatus,
      weblink: weblink ?? this.weblink,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      associatedFabrics: associatedFabrics ?? this.associatedFabrics,
      totalComments: totalComments ?? this.totalComments,
      firstName: firstName ?? this.firstName,
      userName: userName ?? this.userName,
      profilePicture: profilePicture ?? this.profilePicture,
      collectionId: collectionId ?? this.collectionId,
      isFollowed: isFollowed ?? this.isFollowed,
      media: media ?? this.media,
      userDetails: userDetails ?? this.userDetails,
      wasLikedBefore: wasLikedBefore ?? this.wasLikedBefore,
    );
  }

  static Content empty() => Content(
    id: '',
    contentType: ContentType.INITIAL,
    contentFormat: ContentFormat.INITIAL,
    contentGenerationStatus: '',
    isDeleted: false,
    deletedBy: '',
    contentDuration: 0,
    externalReference: '',
    toRecommend: false,
    description: '',
    prompt: '',
    contentName: '',
    contentUrl: '',
    thumbnailUrl: '',
    isLike: false,
    isFavourite: false,
    likeCount: 0,
    finalBoost: 0.0,
    recencyBoost: 0.0,
    watermarkedUrl: '',
    watermarkStatus: '',
    weblink: '',
    createdAt: null,
    updatedAt: null,
    associatedFabrics: const [],
    totalComments: 0,
    firstName: '',
    userName: '',
    profilePicture: '',
    collectionId: '',
    isFollowed: false,
    media: const [],
    userDetails: const UserDetails(),
    wasLikedBefore: false,
  );
}

class MediaItem {
  final String id;
  final String mediaType;
  final String url;

  const MediaItem({this.id = '', this.mediaType = '', this.url = ''});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

class UserDetails {
  final bool isLike;
  final bool isFavourite;
  final String firstName;
  final String userName;
  final String profilePicture;
  final String collectionId;
  final bool isFollowed;

  const UserDetails({
    this.isLike = false,
    this.isFavourite = false,
    this.firstName = '',
    this.userName = '',
    this.profilePicture = '',
    this.collectionId = '',
    this.isFollowed = false,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      isLike: json['isLike'] as bool? ?? false,
      isFavourite: json['isFavourite'] as bool? ?? false,
      firstName: json['firstName']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
      collectionId: json['collectionId']?.toString() ?? '',
      isFollowed: json['isFollowed'] as bool? ?? false,
    );
  }
}

class AssociatedFabric {
  final String id;
  final String name;
  final String fabricThumbnail;
  final String transparentBackgroundThumbnail;
  final String imageUrl;
  final String fabricDescription;
  final String createdUserName;
  final String createdUserId;
  final String createdUserProfileImg;
  final int mappedContentCount;
  final bool isEligible;

  const AssociatedFabric({
    this.id = '',
    this.name = '',
    this.fabricThumbnail = '',
    this.transparentBackgroundThumbnail = '',
    this.imageUrl = '',
    this.fabricDescription = '',
    this.createdUserName = '',
    this.createdUserId = '',
    this.createdUserProfileImg = '',
    this.mappedContentCount = 0,
    this.isEligible = true,
  });

  factory AssociatedFabric.fromJson(Map<String, dynamic> json) {
    return AssociatedFabric(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      fabricThumbnail: json['fabricThumbnail']?.toString() ?? '',
      transparentBackgroundThumbnail:
          json['transparentBackgroundThumbnail']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      fabricDescription: json['fabricDescription']?.toString() ?? '',
      createdUserName: json['createdUserName']?.toString() ?? '',
      createdUserId: json['createdUserId']?.toString() ?? '',
      createdUserProfileImg: json['createdUserProfileImg']?.toString() ?? '',
      mappedContentCount: json['mappedContentCount'] is int
          ? json['mappedContentCount'] as int
          : int.tryParse(json['mappedContentCount']?.toString() ?? '0') ?? 0,
      isEligible: json['isEligible'] as bool? ?? true,
    );
  }

  AssociatedFabric copyWith({
    String? id,
    String? name,
    String? fabricThumbnail,
    String? transparentBackgroundThumbnail,
    String? imageUrl,
    String? fabricDescription,
    String? createdUserName,
    String? createdUserId,
    String? createdUserProfileImg,
    int? mappedContentCount,
    bool? isEligible,
  }) {
    return AssociatedFabric(
      id: id ?? this.id,
      name: name ?? this.name,
      fabricThumbnail: fabricThumbnail ?? this.fabricThumbnail,
      transparentBackgroundThumbnail:
          transparentBackgroundThumbnail ?? this.transparentBackgroundThumbnail,
      imageUrl: imageUrl ?? this.imageUrl,
      fabricDescription: fabricDescription ?? this.fabricDescription,
      createdUserName: createdUserName ?? this.createdUserName,
      createdUserProfileImg:
          createdUserProfileImg ?? this.createdUserProfileImg,
      mappedContentCount: mappedContentCount ?? this.mappedContentCount,
      isEligible: isEligible ?? this.isEligible,
      createdUserId: createdUserId ?? this.createdUserId,
    );
  }
}

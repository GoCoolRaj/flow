class FabricCaption {
  final CaptionType? type;
  final String? text;

  const FabricCaption({
    this.type,
    this.text,
  });

  factory FabricCaption.fromJson(Map<String, dynamic> json) {
    return FabricCaption(
      type: _captionTypeFromString(json["type"]),
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type?.name,
      "text": text,
    };
  }

  static CaptionType _captionTypeFromString(String? type) {
    switch (type) {
      case "narration":
        return CaptionType.narration;
      default:
        return CaptionType.unknown;
    }
  }
}

enum CaptionType {
  unknown,
  dialogue,
  narration,
}

class FabricMQTTItem {
  final String id;
  final String url;
  final String fabricTransparentImage;
  final String? profileImage;
  final bool? isModerated;
  final FabricCaption? captions;

  FabricMQTTItem(
      {required this.id,
      required this.url,
      required this.fabricTransparentImage,
      this.isModerated,
      this.captions,
      this.profileImage});

  factory FabricMQTTItem.fromJson(Map<String, dynamic> json) {
    return FabricMQTTItem(
      id: json["id"] ?? "",
      url: json["url"] ?? "",
      fabricTransparentImage: json["fabricTransparentImage"] ?? "",
      profileImage: json["profile_image"] ?? "",
      isModerated: json["is_moderated"] ?? false,
      captions: json["captions"] != null
          ? FabricCaption.fromJson(json["captions"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "url": url,
      "fabricTransparentImage": fabricTransparentImage,
      "is_moderated": isModerated,
      "profile_image": profileImage,
      "captions": captions?.toJson(),
    };
  }

  static List<FabricMQTTItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => FabricMQTTItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<FabricMQTTItem> list) {
    return list.map((item) => item.toJson()).toList();
  }
}

class FabricMQTT {
  final List<FabricMQTTItem> items;

  FabricMQTT({required this.items});

  factory FabricMQTT.fromJsonList(List<dynamic> jsonList) {
    return FabricMQTT(
      items: FabricMQTTItem.fromJsonList(jsonList),
    );
  }

  List<Map<String, dynamic>> toJsonList() {
    return FabricMQTTItem.toJsonList(items);
  }
}

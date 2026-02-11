class DefaultMoodsResponse {
  final List<DefaultMood> moods;

  DefaultMoodsResponse({required this.moods});

  factory DefaultMoodsResponse.fromJson(Map<String, dynamic> json) {
    final moodsJson = json['default']['moods'] as List<dynamic>;
    final moods =
        moodsJson.map((moodJson) => DefaultMood.fromJson(moodJson)).toList();

    return DefaultMoodsResponse(moods: moods);
  }
}

class DefaultMood {
  final String moodClusterId;
  final String moodName;

  DefaultMood({required this.moodClusterId, required this.moodName});

  factory DefaultMood.fromJson(Map<String, dynamic> json) {
    return DefaultMood(
      moodClusterId: json['moodClusterId'] as String,
      moodName: json['moodName'] as String,
    );
  }
}

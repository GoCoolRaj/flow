enum FeedScope {
  initial,
  following,
  forYou,
  profile,
  fabricContent,
  search,
}

extension FeedScopeExtension on FeedScope {
  String get displayName {
    switch (this) {
      case FeedScope.initial:
        return 'Initial';
      case FeedScope.following:
        return 'Following';
      case FeedScope.forYou:
        return 'For You';
      case FeedScope.profile:
        return 'Profile';
      case FeedScope.fabricContent:
        return 'Fabric Content';
      case FeedScope.search:
        return 'Search';
    }
  }
}

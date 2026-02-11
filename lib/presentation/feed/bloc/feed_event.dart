import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

enum FabricStatus { public, private, deleted }

enum ShowCollectionStatus {
  unknown,
  showCollectionUI,
  showProfileScreenCollectionUI,
}

class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class HomeFeedInit extends FeedEvent {
  final FeedScope feedScope;
  final String? userId;
  final String? fabricId;
  final int? pageNumber;
  final int? playIndex;

  const HomeFeedInit({
    required this.feedScope,
    this.userId,
    this.fabricId,
    this.pageNumber,
    this.playIndex,
  });
}

class HomeFeedStartAt extends FeedEvent {
  final int pageNumber;
  final int playIndex;
  const HomeFeedStartAt({required this.pageNumber, required this.playIndex});

  @override
  List<Object> get props => [pageNumber, playIndex];
}

class HomeHashtagUpdated extends FeedEvent {
  final String hashtag;
  const HomeHashtagUpdated({required this.hashtag});
}

class HomeFeedsRequested extends FeedEvent {
  final int? pageNumber;
  final int? playIndex;

  const HomeFeedsRequested({this.pageNumber, this.playIndex});
}

class HomeFeedLoadMoreRequested extends FeedEvent {
  const HomeFeedLoadMoreRequested();
}

class HomeFeedInitializeControllers extends FeedEvent {
  final int startIndex;
  final int endIndex;
  final bool fromFirst;

  const HomeFeedInitializeControllers({
    required this.startIndex,
    required this.endIndex,
    required this.fromFirst,
  });
}

class FeedClearControllers extends FeedEvent {
  const FeedClearControllers();
}

class HomeFeedPageChanged extends FeedEvent {
  final int index;
  const HomeFeedPageChanged({required this.index});
}

class HomeFeedPaused extends FeedEvent {
  final bool? isUserInitiated;
  const HomeFeedPaused({this.isUserInitiated = false});
}

class HomeFeedResumed extends FeedEvent {
  final bool? isUserInitiated;
  const HomeFeedResumed({this.isUserInitiated = false});
}

class HomeFeedMutePressed extends FeedEvent {
  final bool isMuted;
  const HomeFeedMutePressed({required this.isMuted});
}

class HomeFeedFavoritePressed extends FeedEvent {
  final bool isFavorite;
  final String id;
  final String? collectionId;
  final bool? isUpdateFavorite;
  final FeedScope? feedScope;
  const HomeFeedFavoritePressed({
    required this.isFavorite,
    required this.id,
    this.isUpdateFavorite,
    this.feedScope,
    this.collectionId,
  });
}

class HomeFeedShowCollectionUI extends FeedEvent {
  final ShowCollectionStatus showCollectionStatus;
  const HomeFeedShowCollectionUI(this.showCollectionStatus);
}

class UpdateContentCollectionDetails extends FeedEvent {
  final String contentId;
  final String? collectionId;
  final String? collectionName;
  final bool isFavorite;

  const UpdateContentCollectionDetails({
    required this.contentId,
    this.collectionId,
    this.collectionName,
    required this.isFavorite,
  });
}

class UpdateContentItems extends FeedEvent {
  final List<String> contentIds;
  final bool isFavorite;
  final String? collectionId;

  const UpdateContentItems({
    required this.contentIds,
    required this.isFavorite,
    this.collectionId,
  });
}

class DownloadAndShareVideo extends FeedEvent {
  const DownloadAndShareVideo();
}

class DownloadAndSaveVideo extends FeedEvent {
  const DownloadAndSaveVideo();
}

class OpenFeedbackDialog extends FeedEvent {
  final bool isOpened;
  const OpenFeedbackDialog(this.isOpened);
}

class HomeFeedLikePressed extends FeedEvent {
  final String contentId;
  const HomeFeedLikePressed({required this.contentId});
}

class HomeFeedDislikePressed extends FeedEvent {
  final String contentId;
  const HomeFeedDislikePressed({required this.contentId});
}

class UpdateHomeContentAfterDeletion extends FeedEvent {
  final List<ContentItem> updatedItems;
  final int deletedIndex;
  final int newPlayingIndex;

  const UpdateHomeContentAfterDeletion({
    required this.updatedItems,
    required this.deletedIndex,
    required this.newPlayingIndex,
  });
}

class HomeRevertLikeState extends FeedEvent {
  final ContentItem item;
  final bool isLike;
  final bool? wasLikedBefore;
  final int likeCount;
  final int itemIndex;
  const HomeRevertLikeState({
    required this.item,
    required this.isLike,
    required this.likeCount,
    required this.wasLikedBefore,
    required this.itemIndex,
  });
}

class UserBlockEvent extends FeedEvent {
  const UserBlockEvent();
}

class CheckPrivateFabrics extends FeedEvent {
  const CheckPrivateFabrics();
}

class HomeDeleteContent extends FeedEvent {
  final int? contentIndex;

  const HomeDeleteContent({this.contentIndex});
}

class UpdateCurrentUser extends FeedEvent {
  final bool isCurrentUser;

  const UpdateCurrentUser({required this.isCurrentUser});
}

class FollowUser extends FeedEvent {
  final String userId;
  const FollowUser({required this.userId});
}

class UpdateFollowStatusUI extends FeedEvent {
  final String userId;
  final bool isFollowed;

  const UpdateFollowStatusUI({required this.userId, required this.isFollowed});
}

class RemoveAssociatedFabricById extends FeedEvent {
  final String fabricId;
  final FabricStatus fabricStatus;

  const RemoveAssociatedFabricById({
    required this.fabricId,
    required this.fabricStatus,
  });
}

class UpdateCommentCount extends FeedEvent {
  final String contentId;
  final int commentCount;
  const UpdateCommentCount({
    required this.contentId,
    required this.commentCount,
  });
}

class UpdateIndexToPlay extends FeedEvent {
  final int index;
  const UpdateIndexToPlay({required this.index});
}

class PlayFirstVideo extends FeedEvent {
  final int index;
  const PlayFirstVideo({required this.index});
}

class ToggleUserContentSelection extends FeedEvent {
  final ContentItem contentItem;
  const ToggleUserContentSelection(this.contentItem);
}

class ClearUserContentSelection extends FeedEvent {
  const ClearUserContentSelection();
}

class DownloadSelectedVideos extends FeedEvent {
  const DownloadSelectedVideos();
}

class CancelBulkDownload extends FeedEvent {
  const CancelBulkDownload();
}

class ShareSelectedVideos extends FeedEvent {
  const ShareSelectedVideos();
}

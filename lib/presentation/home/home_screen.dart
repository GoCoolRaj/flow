import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/components/quilt_dialog.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_view_widget.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_event.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_state.dart';
import 'package:quilt_flow_app/presentation/home/bloc/for_you_bloc.dart';
import 'package:quilt_flow_app/presentation/home/feed_page.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';
import 'package:quilt_flow_app/presentation/home/session_completed_screen.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_bloc.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_event.dart';
import 'package:quilt_flow_app/presentation/open_feedback/open_feedback_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  static FeedScope feedScope = FeedScope.forYou;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late PageController _pageControllerFollowing;
  late PageController _pageControllerForYou;
  late TabController _tabController;
  ForYouBloc? _forYouBloc;
  bool _didInitFeed = false;

  String userId = "";

  @override
  void initState() {
    super.initState();

    _pageControllerFollowing = PageController();
    _pageControllerForYou = PageController();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        HomeScreen.feedScope = FeedScope.following;
      } else {
        HomeScreen.feedScope = FeedScope.forYou;
      }
    });

    userId = GetIt.I<HiveManager>().getFromHive(HiveManager.userIdKey);

    FlutterNativeSplash.remove();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _forYouBloc ??= context.read<ForYouBloc>();
    if (!_didInitFeed) {
      _didInitFeed = true;
      _forYouBloc?.add(const HomeFeedInit(feedScope: FeedScope.forYou));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 0,
            elevation: 0,
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.transparent,
          ),

          body: FeedTabView<ForYouBloc>(
            pageController: _pageControllerForYou,
            userId: userId,
            storageKey: 'ForYouPageView',
            onFeedbackPressed: () {
              showOpenFeedback(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (_forYouBloc != null && !_forYouBloc!.isClosed) {
      _forYouBloc!.add(const FeedClearControllers());
    }
    _pageControllerFollowing.dispose();
    _pageControllerForYou.dispose();
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> disposeMediaMapControllers() async {
    await _forYouBloc?.disposeMediaMapControllers();
  }

  void showOpenFeedback(BuildContext context) {
    context.read<ForYouBloc>().add(const OpenFeedbackDialog(true));
    context.read<ForYouBloc>().add(const HomeFeedPaused(isUserInitiated: true));
    GetIt.I<OpenFeedbackBloc>().add(UpdateFeedbackStatus());
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: QuiltTheme.homeBottomSheetBackground,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      isDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BlocProvider<OpenFeedbackBloc>.value(
            value: GetIt.I<OpenFeedbackBloc>(),
            child: const OpenFeedbackPage(),
          ),
        );
      },
    ).then(
      (value) => {
        if (context.mounted)
          {
            context.read<ForYouBloc>().add(const OpenFeedbackDialog(false)),
            context.read<ForYouBloc>().add(
              const HomeFeedResumed(isUserInitiated: true),
            ),
            if (value != null && value) {showFeedBackSuccessDialog(context)},
          },
      },
    );
  }

  void showFeedBackSuccessDialog(BuildContext context) {
    QuiltDialog(
      type: QuiltDialogType.openFeedback,
      infoImage: Assets.icons.checkCircle.svg(),
      confirmTextStyle: QuiltTheme.openFeedbackStyle.copyWith(
        color: QuiltTheme.primaryLabelColor,
      ),
      confirmButtonDecoration: QuiltTheme.dialogCompletedFilled,
      onConfirm: () {},
    ).show(context);
  }
}

class FeedTabView<T extends FeedBloc> extends StatefulWidget {
  final PageController pageController;
  final String userId;
  final String storageKey;
  final VoidCallback? onFeedbackPressed;

  const FeedTabView({
    super.key,
    required this.pageController,
    required this.userId,
    required this.storageKey,
    this.onFeedbackPressed,
  });

  @override
  State<FeedTabView<T>> createState() => _FeedTabViewState<T>();
}

class _FeedTabViewState<T extends FeedBloc> extends State<FeedTabView<T>>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<T, FeedState>(
      listener: (context, feedState) {
        if (feedState.showCollectionStatus ==
            ShowCollectionStatus.showCollectionUI) {
          context.read<T>().add(
            const HomeFeedShowCollectionUI(ShowCollectionStatus.unknown),
          );
          CollectionsViewWidget.show(context);
        } else if (feedState.contentItems.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (widget.pageController.hasClients &&
                feedState.feedState == HomeFeedState.fetchingFeeds) {
              widget.pageController.jumpToPage(0);
            }
          });
        }
      },
      builder: (context, feedState) {
        if (feedState.feedState == HomeFeedState.fetchedNoData &&
            feedState.contentItems.isEmpty &&
            feedState.feedScope == FeedScope.following) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Follow an account to see their \nlatest videos here",
                  style: QuiltTheme.simpleWhiteTextStyle.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        final bool showSessionCompletedPage =
            feedState.hasReachedEnd && feedState.contentItems.isNotEmpty;
        return Stack(
          children: [
            RefreshIndicator(
              color: QuiltTheme.primaryLabelColor,
              backgroundColor: QuiltTheme.dialogBackgroundColor,
              onRefresh: () {
                context.read<T>().add(
                  HomeFeedInit(feedScope: FeedScope.forYou),
                );
                if (widget.pageController.hasClients &&
                    widget.pageController.positions.isNotEmpty) {
                  widget.pageController.jumpToPage(0);
                }
                return Future.value();
              },
              child: VisibilityDetector(
                key: Key("visibility_detector_key_${widget.storageKey}"),
                onVisibilityChanged: (info) {
                  if (!mounted) return;
                  if (info.visibleFraction == 1) {
                    context.read<T>().add(const HomeFeedResumed());
                    WidgetsBinding.instance.removeObserver(this);
                    WidgetsBinding.instance.addObserver(this);
                  } else {
                    context.read<T>().add(const HomeFeedPaused());
                    WidgetsBinding.instance.removeObserver(this);
                  }
                },
                child: PageView.builder(
                  key: PageStorageKey(widget.storageKey),
                  scrollDirection: Axis.vertical,
                  itemCount:
                      feedState.contentItems.length +
                      (showSessionCompletedPage ? 1 : 0),
                  controller: widget.pageController,
                  onPageChanged: (value) {
                    if (showSessionCompletedPage &&
                        value == feedState.contentItems.length) {
                      context.read<T>().add(
                        const HomeFeedPaused(isUserInitiated: true),
                      );
                      return;
                    }
                    context.read<T>().add(HomeFeedPageChanged(index: value));
                  },
                  itemBuilder: (context, index) {
                    final homeState = feedState;
                    if (showSessionCompletedPage &&
                        index == homeState.contentItems.length) {
                      return const SessionCompletedScreen();
                    }
                    final hideFeedback =
                        homeState.hasReachedEnd &&
                        homeState.contentItems.isNotEmpty &&
                        homeState.playingIndex ==
                            homeState.contentItems.length - 1;
                    return FeedPage<T>(
                      feedBloc: context.read<T>(),
                      feedScope: homeState.feedScope,
                      userId: widget.userId,
                      videoPlayerController:
                          homeState.mediaMap[index]?.videoPlayerController,
                      contentItem: homeState.contentItems[index],
                      isMuted: homeState.isMuted,
                      thumbnailPath: homeState.mediaMap[index]?.thumbnailPath,
                      showLoading:
                          (homeState.feedState == HomeFeedState.fetchingFeeds &&
                          index == homeState.contentItems.length - 1),
                      isPaused: homeState.isPaused,
                      onFeedPressed: () {
                        if (homeState.isPaused) {
                          context.read<T>().add(
                            const HomeFeedResumed(isUserInitiated: true),
                          );
                        } else {
                          context.read<T>().add(
                            const HomeFeedPaused(isUserInitiated: true),
                          );
                        }
                      },
                      onDoubleTapDown: (details) {
                        return;
                      },
                      onCommentPressed: () {},
                      showFeedback: !hideFeedback,
                      onFeedbackPressed: widget.onFeedbackPressed,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

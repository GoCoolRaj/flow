import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_request.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/domain/home/use_cases/for_you_feed_usecase.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';

class ForYouBloc extends FeedBloc {
  ForYouBloc({required super.userId});

  @override
  Future<List<ContentItem>> fetchFeeds(FeedsRequest request) async {
    try {
      final response = await safeExecute<ContentFeedResponse>(
        function: () async {
          return await GetIt.I.get<ForYouFeedUseCase>().execute(
            request: request,
          );
        },
        showLoading: false,
        showError: false,
      );

      return response?.data ?? [];
    } catch (_) {
      return [];
    }
  }
}

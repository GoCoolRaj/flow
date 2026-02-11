import 'package:quilt_flow_app/domain/home/model/feeds_request.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';

abstract class HomeRepository {
  Future<ContentFeedResponse> forYouFeed(FeedsRequest request);
}

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/network/core/dio_client.dart';
import 'package:quilt_flow_app/domain/home/home_repository.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_request.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';

class HomeApi extends HomeRepository {
  final _dioClient = GetIt.I<DioClient>();

  final String forYouFeedPath = '/api/ugc/v1/contents/content';

  @override
  Future<ContentFeedResponse> forYouFeed(FeedsRequest request) {
    return _dioClient.getRequest(
      forYouFeedPath,
      sendCompleteResponse: true,
      queryParameters: request.toJson(),
      parseDataJson: ContentFeedResponse.fromJson,
    );
  }
}

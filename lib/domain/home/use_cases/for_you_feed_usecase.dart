import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/home/home_repository.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';

class ForYouFeedUseCase extends BaseUseCase {
  final _homeRepository = GetIt.instance.get<HomeRepository>();

  @override
  Future<ContentFeedResponse> execute({request}) {
    return _homeRepository.forYouFeed(request!);
  }
}

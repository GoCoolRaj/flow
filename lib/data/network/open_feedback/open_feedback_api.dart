import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/network/core/dio_client.dart';
import 'package:quilt_flow_app/domain/open_feedback/model/save_open_feedback_response.dart';
import 'package:quilt_flow_app/domain/open_feedback/open_feedback_repository.dart';
import 'package:quilt_flow_app/domain/open_feedback/use_cases/save_feedback_use_cases.dart';

class OpenFeedbackApi implements OpenFeedbackRepository {
  final _dioClient = GetIt.I<DioClient>();
  static const String saveFeedback = '/api/ugc/v1/feedback/save-feedback';

  @override
  Future<SaveOpenFeedbackResponse> saveOpenFeedback(
    SaveFeedbackRequest request,
  ) async {
    final createProfileResponse = await _dioClient
        .postRequest<SaveOpenFeedbackResponse>(
          saveFeedback,
          data: request.toJson(),
          parseDataJson: SaveOpenFeedbackResponse.fromJson,
        );

    return createProfileResponse;
  }
}

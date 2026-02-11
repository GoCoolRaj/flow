import 'package:quilt_flow_app/domain/open_feedback/model/save_open_feedback_response.dart';
import 'package:quilt_flow_app/domain/open_feedback/use_cases/save_feedback_use_cases.dart';

abstract class OpenFeedbackRepository {
  Future<SaveOpenFeedbackResponse> saveOpenFeedback(
    SaveFeedbackRequest request,
  );
}

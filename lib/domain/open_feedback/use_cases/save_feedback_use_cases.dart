import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/open_feedback/model/save_open_feedback_response.dart';
import 'package:quilt_flow_app/domain/open_feedback/open_feedback_repository.dart';

class SaveFeedbackUseCases
    implements BaseUseCase<SaveFeedbackRequest, SaveOpenFeedbackResponse> {
  final _openFeedbackRepository = GetIt.I<OpenFeedbackRepository>();

  @override
  Future<SaveOpenFeedbackResponse> execute({SaveFeedbackRequest? request}) {
    return _openFeedbackRepository.saveOpenFeedback(request!);
  }
}

class SaveFeedbackRequest {
  final String userId;
  final int rating;
  final String overallFeedback;

  SaveFeedbackRequest({
    required this.userId,
    required this.rating,
    required this.overallFeedback,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rating': rating,
      'overallFeedback': overallFeedback,
    };
  }

  String toJson() => json.encode(toMap());
}

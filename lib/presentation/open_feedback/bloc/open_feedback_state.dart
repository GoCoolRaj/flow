import 'package:equatable/equatable.dart';

enum OpenFeedbackStatus {
  unknown,
  sendingRequest,
  feedbackSubmitSuccess,
  feedbackSubmitFailed,
}

class OpenFeedbackState extends Equatable {
  final int selectedPosition;
  final String feedback;
  final bool isSubmitEnabled;
  final OpenFeedbackStatus status;

  const OpenFeedbackState({
    this.selectedPosition = -1,
    this.feedback = '',
    this.isSubmitEnabled = false,
    this.status = OpenFeedbackStatus.unknown,
  });

  OpenFeedbackState copyWith({
    int? selectedPosition,
    String? feedback,
    bool? isSubmitEnabled,
    OpenFeedbackStatus? status,
    bool? isApiCalling,
  }) {
    return OpenFeedbackState(
      selectedPosition: selectedPosition ?? this.selectedPosition,
      feedback: feedback ?? this.feedback,
      isSubmitEnabled: isSubmitEnabled ?? this.isSubmitEnabled,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        selectedPosition,
        feedback,
        isSubmitEnabled,
        status,
      ];
}

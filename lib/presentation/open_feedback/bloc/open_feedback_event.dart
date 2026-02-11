import 'package:equatable/equatable.dart';

sealed class OpenFeedbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PositionChanged extends OpenFeedbackEvent {
  final int position;
  PositionChanged(this.position);
}

class FeedbackTextChanged extends OpenFeedbackEvent {
  final String feedback;
  FeedbackTextChanged(this.feedback);
}

class SubmitFeedback extends OpenFeedbackEvent {
  SubmitFeedback();
}

class UpdateFeedbackStatus extends OpenFeedbackEvent {}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/open_feedback/model/save_open_feedback_response.dart';
import 'package:quilt_flow_app/domain/open_feedback/use_cases/save_feedback_use_cases.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_event.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_state.dart';

class OpenFeedbackBloc extends BaseBloc<OpenFeedbackEvent, OpenFeedbackState> {
  late final _saveFeedbackUseCases = getIt.get<SaveFeedbackUseCases>();
  late final _hiveManager = getIt.get<HiveManager>();

  OpenFeedbackBloc() : super(const OpenFeedbackState()) {
    on<PositionChanged>(_onPositionChanged);
    on<FeedbackTextChanged>(_onFeedbackTextChanged);
    on<SubmitFeedback>(_onSubmitFeedback);
    on<UpdateFeedbackStatus>(_onUpdateFeedbackStatus);
  }
  void _onPositionChanged(
    PositionChanged event,
    Emitter<OpenFeedbackState> emit,
  ) {
    emit(
      state.copyWith(
        selectedPosition: event.position,
        isSubmitEnabled: event.position != -1 && state.feedback.isNotEmpty,
      ),
    );
  }

  void _onFeedbackTextChanged(
    FeedbackTextChanged event,
    Emitter<OpenFeedbackState> emit,
  ) {
    emit(
      state.copyWith(
        feedback: event.feedback,
        isSubmitEnabled:
            event.feedback.isNotEmpty && state.selectedPosition != -1,
      ),
    );
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedback event,
    Emitter<OpenFeedbackState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: OpenFeedbackStatus.sendingRequest,
          isApiCalling: true,
        ),
      );
      final response = await safeExecute<SaveOpenFeedbackResponse>(
        function: () async {
          return await _saveFeedbackUseCases.execute(
            request: SaveFeedbackRequest(
              userId: _hiveManager.getFromHive(HiveManager.userIdKey)!,
              rating: state.selectedPosition,
              overallFeedback: state.feedback,
            ),
          );
        },
        showLoading: true,
        showError: true,
      );
      if (response != null) {
        emit(state.copyWith(status: OpenFeedbackStatus.feedbackSubmitSuccess));
      } else {
        emit(state.copyWith(status: OpenFeedbackStatus.feedbackSubmitFailed));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OpenFeedbackStatus.feedbackSubmitFailed,
          isApiCalling: false,
        ),
      );
    }
  }

  void _onUpdateFeedbackStatus(
    UpdateFeedbackStatus event,
    Emitter<OpenFeedbackState> emit,
  ) {
    emit(
      state.copyWith(
        status: OpenFeedbackStatus.unknown,
        feedback: "",
        selectedPosition: -1,
        isSubmitEnabled: false,
      ),
    );
  }
}

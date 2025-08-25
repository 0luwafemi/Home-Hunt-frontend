import 'package:flutter/material.dart';
import '../services/feedback_service.dart';
import '../models/feedback_request.dart';

class FeedbackProvider extends ChangeNotifier {
  final FeedbackService _service;

  FeedbackProvider(this._service);

  bool _isSubmitting = false;
  String? _error;
  bool _submissionSuccess = false;

  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  bool get submissionSuccess => _submissionSuccess;

  /// Submits feedback and updates state accordingly
  Future<void> submitFeedback(FeedbackRequest request) async {
    _setSubmittingState();

    try {
      await _service.submitFeedback(request);
      _submissionSuccess = true;
    } catch (e, stackTrace) {
      _error = 'Failed to submit feedback: ${e.toString()}';
      // Optionally log stackTrace for debugging
      // debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Resets the feedback submission state
  void resetState() {
    _isSubmitting = false;
    _error = null;
    _submissionSuccess = false;
    notifyListeners();
  }

  /// Internal helper to set initial submission state
  void _setSubmittingState() {
    _isSubmitting = true;
    _error = null;
    _submissionSuccess = false;
    notifyListeners();
  }
}

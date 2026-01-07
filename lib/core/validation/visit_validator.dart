import '../../features/visits/data/models/visit_model.dart';
import '../errors/app_exceptions.dart';

/// Visit Validator
/// 
/// Validates visit operations per PRD Section 17 and 18 requirements.
class VisitValidator {
  VisitValidator._();

  /// Validate signature exists before visit completion
  /// 
  /// PRD Rule: Signature required for visit completion (Section 18).
  static void validateSignatureRequired(VisitModel visit, {String? signatureUrl}) {
    if (signatureUrl == null || signatureUrl.isEmpty) {
      throw ValidationException.signatureRequiredError();
    }
  }

  /// Validate state transition is allowed
  /// 
  /// PRD Rule: State transitions must follow lifecycle rules (Section 17.1).
  static void validateStateTransition(VisitModel visit, VisitStatus newStatus) {
    final currentStatus = visit.status;

    // Allowed transitions per PRD Section 17.1
    final allowedTransitions = <VisitStatus, List<VisitStatus>>{
      VisitStatus.scheduled: [VisitStatus.inProgress, VisitStatus.cancelled],
      VisitStatus.inProgress: [VisitStatus.paused, VisitStatus.completed, VisitStatus.cancelled],
      VisitStatus.paused: [VisitStatus.inProgress, VisitStatus.cancelled],
      VisitStatus.completed: [], // Completed visits are immutable
      VisitStatus.cancelled: [], // Cancelled visits cannot transition
    };

    final allowed = allowedTransitions[currentStatus] ?? [];
    
    if (!allowed.contains(newStatus)) {
      throw ConflictException.stateTransitionConflict(
        currentStatus.name,
        newStatus.name,
      );
    }
  }

  /// Validate visit can be started
  static void validateCanStart(VisitModel visit) {
    if (visit.status != VisitStatus.scheduled) {
      throw ConflictException.stateTransitionConflict(
        visit.status.name,
        VisitStatus.inProgress.name,
      );
    }
  }

  /// Validate visit can be paused
  static void validateCanPause(VisitModel visit) {
    if (visit.status != VisitStatus.inProgress) {
      throw ConflictException.stateTransitionConflict(
        visit.status.name,
        VisitStatus.paused.name,
      );
    }
  }

  /// Validate visit can be resumed
  static void validateCanResume(VisitModel visit) {
    if (visit.status != VisitStatus.paused) {
      throw ConflictException.stateTransitionConflict(
        visit.status.name,
        VisitStatus.inProgress.name,
      );
    }
  }

  /// Validate visit can be completed
  static void validateCanComplete(VisitModel visit, {String? signatureUrl}) {
    // Check state transition
    if (visit.status != VisitStatus.inProgress && visit.status != VisitStatus.paused) {
      throw ConflictException.stateTransitionConflict(
        visit.status.name,
        VisitStatus.completed.name,
      );
    }

    // Check signature requirement
    validateSignatureRequired(visit, signatureUrl: signatureUrl);
  }

  /// Validate visit can be cancelled
  /// 
  /// PRD Rule: Cancellation is web_admin only (documented for Phase 2).
  static void validateCanCancel(VisitModel visit) {
    // Note: This is for web_admin only per PRD
    // For mobile app, this should not be accessible
    if (visit.status == VisitStatus.completed) {
      throw ValidationException(
        message: 'Completed visits cannot be cancelled.',
        code: 'VISIT_COMPLETED',
      );
    }

    if (visit.status == VisitStatus.cancelled) {
      throw ValidationException(
        message: 'Visit is already cancelled.',
        code: 'VISIT_ALREADY_CANCELLED',
      );
    }
  }

  /// Validate visit is not immutable
  static void validateNotImmutable(VisitModel visit) {
    if (visit.status == VisitStatus.completed) {
      throw ValidationException(
        message: 'Completed visits are immutable.',
        code: 'VISIT_IMMUTABLE',
      );
    }
  }
}



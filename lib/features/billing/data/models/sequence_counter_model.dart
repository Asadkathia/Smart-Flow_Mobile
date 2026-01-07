import 'package:freezed_annotation/freezed_annotation.dart';

part 'sequence_counter_model.freezed.dart';
part 'sequence_counter_model.g.dart';

/// Entity types for sequence counters
enum SequenceEntityType {
  @JsonValue('quote')
  quote,
  @JsonValue('invoice')
  invoice,
  @JsonValue('job')
  job,
}

/// Sequence Counter Model (PRD Section 3.23)
/// 
/// Manages auto-incrementing sequence numbers for quotes, invoices, and jobs.
/// Numbers are formatted as: {PREFIX}-{ORG_PREFIX}-{SEQUENCE:04d}
@freezed
class SequenceCounterModel with _$SequenceCounterModel {
  const SequenceCounterModel._();

  const factory SequenceCounterModel({
    required String id,
    required String orgId,
    required SequenceEntityType entityType,
    @Default(0) int currentSequence,
    DateTime? updatedAt,
  }) = _SequenceCounterModel;

  factory SequenceCounterModel.fromJson(Map<String, dynamic> json) =>
      _$SequenceCounterModelFromJson(json);

  /// Get the next sequence number (without incrementing)
  int get nextSequence => currentSequence + 1;

  /// Format the next number with prefix
  String formatNextNumber(String orgPrefix) {
    final prefix = _getPrefix();
    final paddedSequence = nextSequence.toString().padLeft(4, '0');
    return '$prefix-$orgPrefix-$paddedSequence';
  }

  /// Get the prefix for this entity type
  String _getPrefix() {
    switch (entityType) {
      case SequenceEntityType.quote:
        return 'QT';
      case SequenceEntityType.invoice:
        return 'INV';
      case SequenceEntityType.job:
        return 'JOB';
    }
  }

  /// Static helper to format a number
  static String formatNumber(SequenceEntityType type, String orgPrefix, int sequence) {
    String prefix;
    switch (type) {
      case SequenceEntityType.quote:
        prefix = 'QT';
        break;
      case SequenceEntityType.invoice:
        prefix = 'INV';
        break;
      case SequenceEntityType.job:
        prefix = 'JOB';
        break;
    }
    final paddedSequence = sequence.toString().padLeft(4, '0');
    return '$prefix-$orgPrefix-$paddedSequence';
  }
}




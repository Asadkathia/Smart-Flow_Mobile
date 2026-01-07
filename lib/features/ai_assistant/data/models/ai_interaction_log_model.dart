import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_interaction_log_model.freezed.dart';
part 'ai_interaction_log_model.g.dart';

/// AI Interaction Log Model (PRD Section 3.17)
/// 
/// Logs all AI assistant interactions for auditing and cost tracking.
/// Includes prompts, responses, token usage, and model information.
@freezed
class AiInteractionLogModel with _$AiInteractionLogModel {
  const AiInteractionLogModel._();

  const factory AiInteractionLogModel({
    required String id,
    required String orgId,
    required String technicianId,
    required String visitId,
    required String prompt,
    required String response,
    required String model,
    int? tokensIn,
    int? tokensOut,
    DateTime? createdAt,
  }) = _AiInteractionLogModel;

  factory AiInteractionLogModel.fromJson(Map<String, dynamic> json) =>
      _$AiInteractionLogModelFromJson(json);

  /// Total tokens used in this interaction
  int get totalTokens => (tokensIn ?? 0) + (tokensOut ?? 0);

  /// Check if this interaction included image analysis
  bool get hadImageAnalysis => prompt.contains('[IMAGE]') || prompt.contains('image');

  /// Truncated prompt for display (first 100 chars)
  String get truncatedPrompt {
    if (prompt.length <= 100) return prompt;
    return '${prompt.substring(0, 100)}...';
  }

  /// Truncated response for display (first 200 chars)
  String get truncatedResponse {
    if (response.length <= 200) return response;
    return '${response.substring(0, 200)}...';
  }
}




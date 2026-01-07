import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_models.freezed.dart';
part 'ai_models.g.dart';

/// AI Chat Message Model
/// 
/// Represents a message in the AI assistant chat.
@freezed
class AiChatMessage with _$AiChatMessage {
  const factory AiChatMessage({
    required String id,
    required String role, // 'user' or 'assistant'
    required String content,
    String? imageUrl,
    DateTime? createdAt,
  }) = _AiChatMessage;

  factory AiChatMessage.fromJson(Map<String, dynamic> json) =>
      _$AiChatMessageFromJson(json);
}

/// AI Chat Message extensions
extension AiChatMessageX on AiChatMessage {
  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get hasImage => imageUrl != null;
}

/// AI Request Model
/// 
/// Request to the AI assistant API.
@freezed
class AiRequest with _$AiRequest {
  const factory AiRequest({
    required String visitId,
    required String message,
    String? imageBase64,
    List<AiChatMessage>? conversationHistory,
  }) = _AiRequest;

  factory AiRequest.fromJson(Map<String, dynamic> json) =>
      _$AiRequestFromJson(json);
}

/// AI Response Model
/// 
/// Response from the AI assistant API.
@freezed
class AiResponse with _$AiResponse {
  const factory AiResponse({
    required String message,
    List<String>? suggestions,
    String? confidence,
  }) = _AiResponse;

  factory AiResponse.fromJson(Map<String, dynamic> json) =>
      _$AiResponseFromJson(json);
}

/// AI Suggestion Model
/// 
/// Represents an AI-generated suggestion for services or materials.
@freezed
class AiSuggestion with _$AiSuggestion {
  const factory AiSuggestion({
    required String type, // 'service' or 'material'
    required String name,
    required String description,
    double? estimatedPrice,
    String? reasoning,
  }) = _AiSuggestion;

  factory AiSuggestion.fromJson(Map<String, dynamic> json) =>
      _$AiSuggestionFromJson(json);
}

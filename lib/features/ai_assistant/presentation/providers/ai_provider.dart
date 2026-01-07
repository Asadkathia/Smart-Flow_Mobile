import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_models.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/datasources/ai_mock_data.dart';
import '../../../../shared/data/remote/api_client.dart';
import '../../../../shared/data/services/media_upload_service.dart';

/// AI Repository Provider
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final mediaUploadService = ref.watch(mediaUploadServiceProvider);
  return AiRepository(apiClient, mediaUploadService: mediaUploadService);
});

/// AI Chat Messages Provider
/// 
/// Manages the conversation history with the AI assistant.
class AiChatNotifier extends StateNotifier<List<AiChatMessage>> {
  final AiRepository _repository;
  final String _visitId;

  AiChatNotifier(this._repository, this._visitId)
      : super(AiMockData.getInitialMessages());

  /// Send a message to the AI
  Future<void> sendMessage(String message, {File? image}) async {
    // Add user message
    final userMessage = AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      imageUrl: image != null ? 'local_image' : null,
      createdAt: DateTime.now(),
    );
    state = [...state, userMessage];

    try {
      // Get AI response
      final response = await _repository.sendMessage(
        visitId: _visitId,
        message: message,
        image: image,
        conversationHistory: state,
      );

      // Add AI response
      final aiMessage = AiChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: 'assistant',
        content: response.message,
        createdAt: DateTime.now(),
      );
      state = [...state, aiMessage];
    } catch (e) {
      // Add error message
      final errorMessage = AiChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: 'assistant',
        content: 'Sorry, I encountered an error. Please try again.',
        createdAt: DateTime.now(),
      );
      state = [...state, errorMessage];
    }
  }

  /// Clear conversation
  void clearConversation() {
    state = AiMockData.getInitialMessages();
  }
}

/// AI Chat Provider (scoped to visit)
final aiChatProvider = StateNotifierProvider.family<AiChatNotifier, List<AiChatMessage>, String>(
  (ref, visitId) {
    final repository = ref.watch(aiRepositoryProvider);
    return AiChatNotifier(repository, visitId);
  },
);

/// AI Suggestions Provider
final aiSuggestionsProvider = FutureProvider.family<List<AiSuggestion>, String>(
  (ref, visitId) async {
    final repository = ref.watch(aiRepositoryProvider);
    return repository.getSuggestions(visitId: visitId);
  },
);

/// AI Loading State Provider
final aiLoadingProvider = StateProvider<bool>((ref) => false);



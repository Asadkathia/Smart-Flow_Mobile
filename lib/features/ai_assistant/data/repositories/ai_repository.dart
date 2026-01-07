import 'dart:io';
import '../models/ai_models.dart';
import '../datasources/ai_mock_data.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/services/media_upload_service.dart';

/// AI Assistant Repository
/// 
/// Handles all AI assistant-related data operations.
class AiRepository {
  final ApiClient _apiClient;
  final MediaUploadService? _mediaUploadService;

  AiRepository(this._apiClient, {MediaUploadService? mediaUploadService})
      : _mediaUploadService = mediaUploadService;

  /// Send a message to the AI assistant
  Future<AiResponse> sendMessage({
    required String visitId,
    required String message,
    File? image,
    List<AiChatMessage>? conversationHistory,
  }) async {
    try {
      // Upload image first if provided
      String? imageUrl;
      if (image != null && _mediaUploadService != null) {
        try {
          imageUrl = await _mediaUploadService!.uploadImage(
            image,
            'visits/$visitId/ai',
            entityId: visitId,
            entityType: 'visit',
          );
        } catch (e) {
          // If upload fails, continue without image
          imageUrl = null;
        }
      }

      // TODO (Phase 2): Replace with actual API call when backend is ready
      // final request = AiRequest(
      //   visitId: visitId,
      //   message: message,
      //   imageUrl: imageUrl,
      //   conversationHistory: conversationHistory,
      // );
      //
      // final response = await _apiClient.post('/v1/ai/assist', data: request.toJson());
      // return AiResponse.fromJson(response.data);

      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));
      return AiMockData.getMockResponse(message);
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  /// Get AI suggestions for the current visit
  Future<List<AiSuggestion>> getSuggestions({
    required String visitId,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiClient.get('/v1/ai/suggestions', queryParameters: {
      //   'visit_id': visitId,
      // });
      // return (response.data as List).map((e) => AiSuggestion.fromJson(e)).toList();

      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 800));
      return AiMockData.getMockSuggestions();
    } catch (e) {
      throw Exception('Failed to get AI suggestions: $e');
    }
  }

  /// Analyze an image with AI
  Future<AiResponse> analyzeImage({
    required String visitId,
    required File image,
    String? question,
  }) async {
    try {
      // Upload image first
      String? imageUrl;
      if (_mediaUploadService != null) {
        try {
          imageUrl = await _mediaUploadService!.uploadImage(
            image,
            'visits/$visitId/ai',
            entityId: visitId,
            entityType: 'visit',
          );
        } catch (e) {
          throw Exception('Failed to upload image for analysis: $e');
        }
      }

      // TODO (Phase 2): Replace with actual API call when backend is ready
      // final request = AiRequest(
      //   visitId: visitId,
      //   message: question ?? 'What do you see in this image?',
      //   imageUrl: imageUrl,
      // );
      //
      // final response = await _apiClient.post('/v1/ai/analyze', data: request.toJson());
      // return AiResponse.fromJson(response.data);

      // Mock data for now
      await Future.delayed(const Duration(seconds: 2));
      return const AiResponse(
        message: 'Based on the image analysis, I can see:\n\n• HVAC unit components\n• Possible wear on connections\n• Filter location\n\nRecommendations:\n1. Replace the air filter\n2. Check refrigerant lines\n3. Inspect electrical connections\n\nWould you like me to suggest specific materials?',
        suggestions: [
          'Replace air filter',
          'Check refrigerant',
          'Inspect connections',
          'Add to quote',
        ],
        confidence: 'high',
      );
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }
}



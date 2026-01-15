import 'dart:convert';
import 'dart:io';
import '../models/ai_models.dart';
import '../datasources/ai_mock_data.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/services/media_upload_service.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/config/app_config.dart';
import 'package:smartflowpro/core/config/supabase_config.dart';
import 'package:smartflowpro/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart';

/// AI Assistant Repository
/// 
/// Handles all AI assistant-related data operations.
/// Now calls OpenAI API directly instead of using Supabase Edge Functions
/// to avoid ES256 JWT authentication issues.
class AiRepository {
  final ApiClient _apiClient;
  final MediaUploadService? _mediaUploadService;
  final Dio _openaiClient;
  final SupabaseClient _supabase;

  AiRepository(
    this._apiClient, {
    MediaUploadService? mediaUploadService,
  })  : _mediaUploadService = mediaUploadService,
        _openaiClient = Dio(
          BaseOptions(
            baseUrl: 'https://api.openai.com/v1',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${SupabaseConfig.openaiApiKey}',
            },
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 60),
          ),
        ),
        _supabase = Supabase.instance.client;

  /// Fetch visit context from Supabase REST API
  Future<String?> _fetchVisitContext(String visitId) async {
    try {
      if (visitId == 'default-visit') return null;

      // Fetch visit with job, customer, and property details
      final visitUrl = '${ApiEndpoints.restApiBaseFull}/visits'
          '?id=eq.$visitId'
          '&select=*,job:jobs(*,customer:customers(name,phone,email),property:properties(address,latitude,longitude))';
      
      final visitResponse = await _apiClient.get(visitUrl);
      
      if (visitResponse.data is List && (visitResponse.data as List).isNotEmpty) {
        final visit = (visitResponse.data as List)[0] as Map<String, dynamic>;
        final job = visit['job'] as Map<String, dynamic>?;
        final customer = job?['customer'] as Map<String, dynamic>?;
        final property = job?['property'] as Map<String, dynamic>?;

        // Fetch recent notes
        String notesContext = '';
        try {
          final notesUrl = '${ApiEndpoints.restApiBaseFull}/notes'
              '?visit_id=eq.$visitId'
              '&order=created_at.desc'
              '&limit=5';
          final notesResponse = await _apiClient.get(notesUrl);
          if (notesResponse.data is List && (notesResponse.data as List).isNotEmpty) {
            final notes = (notesResponse.data as List).map((n) => n as Map<String, dynamic>).toList();
            notesContext = '\n\nRecent Notes:\n${notes.map((n) => '- ${n['body']} (${n['created_at']})').join('\n')}';
          }
        } catch (e) {
          // Notes fetch failed, continue without them
          Logger.warning('Failed to fetch notes for visit context', e);
        }

        return '''
Current Job Context:
- Job Number: ${job?['job_number'] ?? 'N/A'}
- Service Type: ${job?['service_type'] ?? 'N/A'}
- Priority: ${job?['priority'] ?? 'N/A'}
- Customer: ${customer?['name'] ?? 'N/A'}
- Property Address: ${property?['address'] ?? 'N/A'}
- Visit Status: ${visit['status']}
- Scheduled: ${visit['scheduled_start']}$notesContext
''';
      }
      return null;
    } catch (e) {
      Logger.warning('Failed to fetch visit context', e);
      return null;
    }
  }

  /// Send a message to the AI assistant
  Future<AiResponse> sendMessage({
    required String visitId,
    required String message,
    File? image,
    List<AiChatMessage>? conversationHistory,
  }) async {
    try {
      // Check if OpenAI API key is configured
      if (!SupabaseConfig.isOpenAiConfigured) {
        throw Exception(
          'AI Assistant is not configured.\n\n'
          'Please set OPENAI_API_KEY environment variable to use this feature.'
        );
      }

      // Use mock data if configured
      if (AppConfig.useMockData && !SupabaseConfig.isValid) {
        await Future.delayed(const Duration(seconds: 1));
        return AiMockData.getMockResponse(message);
      }

      // Fetch visit context if visitId is provided
      String? visitContext = await _fetchVisitContext(visitId);

      // Prepare image data - convert to base64 if local file
      String? imageBase64;
      if (image != null) {
        try {
          final imageBytes = await image.readAsBytes();
          imageBase64 = base64Encode(imageBytes);
        } catch (e) {
          Logger.warning('Failed to encode image', e);
          // Continue without image
        }
      }

      // Build messages array for OpenAI
      final messages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': 'You are a helpful assistant for field service technicians. Provide clear, concise, and actionable advice based on the job context provided.${visitContext != null ? '\n\nYou have access to the current job information above.' : ''}',
        },
      ];

      // Build user message with context
      final fullPrompt = visitContext != null
          ? '$visitContext\n\nTechnician Question: $message'
          : message;

      final userMessage = <String, dynamic>{
        'role': 'user',
        'content': <Map<String, dynamic>>[],
      };

      // Add text prompt
      (userMessage['content'] as List<Map<String, dynamic>>).add({
        'type': 'text',
        'text': fullPrompt,
      });

      // Add image if provided
      if (imageBase64 != null) {
        (userMessage['content'] as List<Map<String, dynamic>>).add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$imageBase64',
          },
        });
      }

      messages.add(userMessage);

      // Determine model based on whether image is present
      final hasImage = imageBase64 != null;
      final model = hasImage ? 'gpt-4o-mini' : 'gpt-4o-mini'; // Use gpt-4o-mini for both text and images

      // Call OpenAI API directly
      Logger.info('Calling OpenAI API with model: $model');
      final response = await _openaiClient.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages,
          'max_tokens': 1500,
          'temperature': 0.7,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('OpenAI API error: ${response.statusMessage}');
      }

      final responseData = response.data as Map<String, dynamic>;
      final choices = responseData['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw Exception('No response generated from OpenAI');
      }

      final messageContent = choices[0]['message']['content'] as String?;
      final responseText = messageContent ?? 'No response generated';

      // Optionally log interaction to Supabase (non-blocking)
      _logAiInteraction(visitId, message, responseText, model).catchError((e) {
        Logger.warning('Failed to log AI interaction', e);
      });

      return AiResponse(
        message: responseText,
        suggestions: [],
        confidence: 'high',
      );
    } catch (e) {
      Logger.error('AI Assistant error', e);
      
      // Provide user-friendly error messages
      final errorString = e.toString();
      if (errorString.contains('401') || errorString.contains('Unauthorized')) {
        throw Exception(
          'AI Assistant authentication failed.\n\n'
          'Please check that OPENAI_API_KEY is correctly configured.'
        );
      }
      
      if (errorString.contains('429') || errorString.contains('rate limit')) {
        throw Exception(
          'AI Assistant rate limit exceeded.\n\n'
          'Please try again in a few moments.'
        );
      }
      
      if (errorString.contains('not configured')) {
        throw Exception(errorString);
      }
      
      throw Exception('Failed to get AI response: ${e.toString()}');
    }
  }

  /// Log AI interaction to Supabase database (non-blocking)
  Future<void> _logAiInteraction(
    String visitId,
    String prompt,
    String response,
    String model,
  ) async {
    try {
      // Get current user ID and org ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Get user's org_id from users table
      final userUrl = '${ApiEndpoints.restApiBaseFull}/users?id=eq.$userId&select=org_id';
      final userResponse = await _apiClient.get(userUrl);
      
      if (userResponse.data is List && (userResponse.data as List).isNotEmpty) {
        final user = (userResponse.data as List)[0] as Map<String, dynamic>;
        final orgId = user['org_id'] as String?;
        
        if (orgId != null) {
          // Insert into ai_interaction_logs table
          final logUrl = '${ApiEndpoints.restApiBaseFull}/ai_interaction_logs';
          await _apiClient.post(
            logUrl,
            data: {
              'org_id': orgId,
              'technician_id': userId,
              'visit_id': visitId != 'default-visit' ? visitId : null,
              'prompt': prompt,
              'response': response,
              'model': 'openai-$model',
              'tokens_in': 0, // Could calculate from response if needed
              'tokens_out': 0,
            },
          );
        }
      }
    } catch (e) {
      // Silently fail - logging is not critical
      Logger.debug('Failed to log AI interaction', e);
    }
  }

  /// Get AI suggestions for the current visit
  Future<List<AiSuggestion>> getSuggestions({
    required String visitId,
  }) async {
    try {
      // Use mock data if configured, otherwise call real API
      if (AppConfig.useMockData && !SupabaseConfig.isValid) {
        await Future.delayed(const Duration(milliseconds: 800));
        return AiMockData.getMockSuggestions();
      }
      
      // Suggestions feature not yet implemented
      // Return mock suggestions for now
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
    // Use sendMessage with image
    return sendMessage(
      visitId: visitId,
      message: question ?? 'What do you see in this image? Please analyze it and provide recommendations.',
      image: image,
    );
  }
}

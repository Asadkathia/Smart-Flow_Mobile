import '../models/ai_models.dart';

/// Mock AI Data
/// 
/// Provides sample AI responses for development and testing.
class AiMockData {
  static List<AiChatMessage> getInitialMessages() {
    return [
      AiChatMessage(
        id: '1',
        role: 'assistant',
        content: 'Hello! I\'m your AI assistant. I can help you with:\n\n• Answering questions about the current job\n• Suggesting services or materials\n• Providing troubleshooting guidance\n• Analyzing images\n\nHow can I assist you today?',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static AiResponse getMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('hvac') || lowerMessage.contains('air conditioning')) {
      return const AiResponse(
        message: 'For HVAC systems, I recommend checking the following:\n\n1. Air filter condition\n2. Refrigerant levels\n3. Thermostat settings\n4. Ductwork for leaks\n\nWould you like me to suggest specific materials or services for this job?',
        suggestions: [
          'Check air filter',
          'Test refrigerant levels',
          'Inspect thermostat',
          'Examine ductwork',
        ],
        confidence: 'high',
      );
    } else if (lowerMessage.contains('plumbing') || lowerMessage.contains('pipe') || lowerMessage.contains('leak')) {
      return const AiResponse(
        message: 'For plumbing issues, consider these steps:\n\n1. Identify the source of the leak\n2. Check water pressure\n3. Inspect pipe connections\n4. Test shut-off valves\n\nCommon materials needed: PVC pipes, teflon tape, pipe fittings.',
        suggestions: [
          'Locate leak source',
          'Check water pressure',
          'Inspect connections',
          'Test valves',
        ],
        confidence: 'high',
      );
    } else if (lowerMessage.contains('electrical') || lowerMessage.contains('wiring') || lowerMessage.contains('circuit')) {
      return const AiResponse(
        message: 'For electrical work, safety first! Here are the steps:\n\n1. Turn off power at the breaker\n2. Test circuits with a multimeter\n3. Check wire connections\n4. Inspect circuit breakers\n\nMake sure to follow electrical codes and safety protocols.',
        suggestions: [
          'Turn off power',
          'Test circuits',
          'Check connections',
          'Inspect breakers',
        ],
        confidence: 'high',
      );
    } else if (lowerMessage.contains('price') || lowerMessage.contains('cost') || lowerMessage.contains('quote')) {
      return const AiResponse(
        message: 'I can help you estimate costs based on typical pricing:\n\n• Service call fee: \$100 (standard)\n• Labor: \$125-175/hour depending on complexity\n• Materials: Based on inventory prices\n\nWould you like me to suggest specific line items for your quote?',
        suggestions: [
          'Add service call fee',
          'Estimate labor hours',
          'Review material costs',
          'Create quote draft',
        ],
        confidence: 'medium',
      );
    } else if (lowerMessage.contains('help') || lowerMessage.contains('what can you do')) {
      return const AiResponse(
        message: 'I can assist you with:\n\n✓ Job-specific guidance\n✓ Service and material suggestions\n✓ Troubleshooting steps\n✓ Image analysis (upload a photo)\n✓ Quote line item recommendations\n✓ General technical questions\n\nJust ask me anything related to your current visit!',
        suggestions: [
          'Analyze an image',
          'Suggest materials',
          'Get troubleshooting steps',
          'Estimate costs',
        ],
        confidence: 'high',
      );
    } else {
      return const AiResponse(
        message: 'I understand you\'re asking about the current job. Based on the visit details, I recommend:\n\n1. Assess the situation thoroughly\n2. Check for any safety concerns\n3. Document findings with photos\n4. Consult inventory for needed materials\n\nCould you provide more specific details about what you need help with?',
        suggestions: [
          'Take photos',
          'Check inventory',
          'Review job details',
          'Ask specific question',
        ],
        confidence: 'medium',
      );
    }
  }

  static List<AiSuggestion> getMockSuggestions() {
    return const [
      AiSuggestion(
        type: 'service',
        name: 'HVAC System Inspection',
        description: 'Complete inspection of heating and cooling system',
        estimatedPrice: 150.00,
        reasoning: 'Based on typical HVAC service requirements',
      ),
      AiSuggestion(
        type: 'material',
        name: 'HVAC Filter 16x20x1',
        description: 'Standard air filter replacement',
        estimatedPrice: 24.99,
        reasoning: 'Common filter size for residential systems',
      ),
      AiSuggestion(
        type: 'service',
        name: 'Refrigerant Recharge',
        description: 'Add refrigerant to system',
        estimatedPrice: 200.00,
        reasoning: 'Typical for low refrigerant situations',
      ),
    ];
  }
}




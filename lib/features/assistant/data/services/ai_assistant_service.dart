import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';

class AIAssistantService {
  Future<Map<String, dynamic>> sendMessage(String message) async {
    if (AppConfig.useOpenAI) {
      return await _sendToOpenAI(message);
    } else {
      return await _sendToGemini(message);
    }
  }
  
  Future<Map<String, dynamic>> _sendToOpenAI(String message) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.openAIBaseUrl}/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.openAIApiKey}',
        },
        body: jsonEncode({
          'model': AppConfig.openAIModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant specializing in fruits, nutrition, and healthy eating. Provide concise, friendly responses.'
            },
            {
              'role': 'user',
              'content': message,
            },
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['choices'][0]['message']['content'],
        };
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get response: $e',
      };
    }
  }
  
  Future<Map<String, dynamic>> _sendToGemini(String message) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.geminiBaseUrl}/models/${AppConfig.geminiModel}:generateContent?key=${AppConfig.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'You are a helpful assistant specializing in fruits, nutrition, and healthy eating. Provide concise, friendly responses.\n\nUser: $message'
                }
              ]
            }
          ],
          'generationConfig': {
            'maxOutputTokens': 500,
            'temperature': 0.7,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return {
          'success': true,
          'message': text,
        };
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get response: $e',
      };
    }
  }
}

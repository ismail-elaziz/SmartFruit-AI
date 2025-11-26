import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/ai_assistant_service.dart';
import '../data/services/speech_service.dart';
import '../data/services/tts_service.dart';

// Service providers
final aiAssistantServiceProvider = Provider((ref) => AIAssistantService());
final speechServiceProvider = Provider((ref) => SpeechService());
final ttsServiceProvider = Provider((ref) {
  final service = TextToSpeechService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// Assistant state provider
final assistantStateProvider = StateNotifierProvider<AssistantController, AsyncValue<List<ChatMessage>>>((ref) {
  return AssistantController(
    ref.watch(aiAssistantServiceProvider),
    ref.watch(speechServiceProvider),
    ref.watch(ttsServiceProvider),
  );
});

class AssistantController extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final AIAssistantService _aiService;
  final SpeechService _speechService;
  final TextToSpeechService _ttsService;
  
  AssistantController(this._aiService, this._speechService, this._ttsService) 
      : super(const AsyncValue.data([]));
  
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    
    // Add user message
    final currentMessages = state.value ?? [];
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    state = AsyncValue.data([...currentMessages, userMessage]);
    
    // Get AI response
    final response = await _aiService.sendMessage(message);
    
    if (response['success']) {
      final aiMessage = ChatMessage(
        text: response['message'],
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      state = AsyncValue.data([...currentMessages, userMessage, aiMessage]);
      
      // Speak the response
      await _ttsService.speak(response['message']);
    } else {
      final errorMessage = ChatMessage(
        text: 'Sorry, I encountered an error: ${response['error']}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      state = AsyncValue.data([...currentMessages, userMessage, errorMessage]);
    }
  }
  
  Future<void> startListening(Function(String) onResult) async {
    try {
      await _speechService.initialize();
      await _speechService.startListening(
        onResult: onResult,
        onComplete: () {},
      );
    } catch (e) {
      print('Error starting speech recognition: $e');
    }
  }
  
  Future<void> stopListening() async {
    await _speechService.stopListening();
  }
  
  void clearMessages() {
    state = const AsyncValue.data([]);
  }
  
  bool get isListening => _speechService.isListening;
}

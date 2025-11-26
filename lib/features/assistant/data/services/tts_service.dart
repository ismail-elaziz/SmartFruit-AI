import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    _isInitialized = true;
  }
  
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    await _tts.speak(text);
  }
  
  Future<void> stop() async {
    await _tts.stop();
  }
  
  Future<void> pause() async {
    await _tts.pause();
  }
  
  void dispose() {
    _tts.stop();
  }
}

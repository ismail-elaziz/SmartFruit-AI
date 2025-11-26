import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static late SharedPreferences _prefs;
  
  // API Keys - Store these securely in production
  static const String openAIApiKey = 'YOUR_OPENAI_API_KEY';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  
  // API Configuration
  static const String openAIBaseUrl = 'https://api.openai.com/v1';
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  
  // Model Configuration
  static const String openAIModel = 'gpt-4-turbo-preview';
  static const String geminiModel = 'gemini-pro';
  
  // TFLite Model
  static const String fruitModelPath = 'assets/models/fruit_classifier.tflite';
  static const String labelsPath = 'assets/models/labels.txt';
  
  // App Settings
  static const int maxHistoryItems = 100;
  static const double confidenceThreshold = 0.5;
  
  // Use Gemini by default (set to true for OpenAI)
  static bool useOpenAI = false;
  
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get prefs => _prefs;
  
  static String get activeApiKey => useOpenAI ? openAIApiKey : geminiApiKey;
  static String get activeBaseUrl => useOpenAI ? openAIBaseUrl : geminiBaseUrl;
  static String get activeModel => useOpenAI ? openAIModel : geminiModel;
}

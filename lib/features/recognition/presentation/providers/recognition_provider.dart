import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/fruit_recognition_result.dart';
import '../data/services/fruit_recognition_service.dart';

// Recognition service provider
final fruitRecognitionServiceProvider = Provider<FruitRecognitionService>((ref) {
  final service = FruitRecognitionService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Recognition state provider
final recognitionStateProvider = StateNotifierProvider<RecognitionController, AsyncValue<FruitRecognitionResult?>>((ref) {
  return RecognitionController(ref.watch(fruitRecognitionServiceProvider));
});

class RecognitionController extends StateNotifier<AsyncValue<FruitRecognitionResult?>> {
  final FruitRecognitionService _service;
  
  RecognitionController(this._service) : super(const AsyncValue.data(null));
  
  Future<void> recognizeFruit(File imageFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _service.recognizeFruit(imageFile);
    });
  }
  
  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

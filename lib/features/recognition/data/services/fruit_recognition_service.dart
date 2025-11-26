import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import '../../../../core/config/app_config.dart';
import '../models/fruit_recognition_result.dart';

class FruitRecognitionService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isModelLoaded = false;
  
  static const int INPUT_SIZE = 224;
  static const int NUM_CHANNELS = 3;
  static const double NORMALIZATION_FACTOR = 127.5;
  
  // Initialize the model
  Future<void> loadModel() async {
    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset(AppConfig.fruitModelPath);
      
      // Load labels
      final labelsData = await rootBundle.loadString(AppConfig.labelsPath);
      _labels = labelsData.split('\n').where((label) => label.trim().isNotEmpty).toList();
      
      _isModelLoaded = true;
      print('Model loaded successfully with ${_labels.length} labels');
    } catch (e) {
      print('Error loading model: $e');
      throw Exception('Failed to load model: $e');
    }
  }
  
  // Recognize fruit from image file
  Future<FruitRecognitionResult> recognizeFruit(File imageFile) async {
    if (!_isModelLoaded) {
      await loadModel();
    }
    
    try {
      // Read and decode image
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // Preprocess image
      final input = _preprocessImage(image);
      
      // Prepare output buffer
      final output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
      
      // Run inference
      _interpreter!.run(input, output);
      
      // Get results
      final probabilities = output[0] as List<double>;
      
      // Find the highest confidence
      double maxConfidence = 0.0;
      int maxIndex = 0;
      
      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxConfidence) {
          maxConfidence = probabilities[i];
          maxIndex = i;
        }
      }
      
      return FruitRecognitionResult(
        fruitName: _labels[maxIndex],
        confidence: maxConfidence,
        imageUrl: imageFile.path,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error recognizing fruit: $e');
      throw Exception('Failed to recognize fruit: $e');
    }
  }
  
  // Preprocess image for model input
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize image to model input size
    img.Image resizedImage = img.copyResize(image, width: INPUT_SIZE, height: INPUT_SIZE);
    
    // Normalize pixel values
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        INPUT_SIZE,
        (y) => List.generate(
          INPUT_SIZE,
          (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              (pixel.r - NORMALIZATION_FACTOR) / NORMALIZATION_FACTOR,
              (pixel.g - NORMALIZATION_FACTOR) / NORMALIZATION_FACTOR,
              (pixel.b - NORMALIZATION_FACTOR) / NORMALIZATION_FACTOR,
            ];
          },
        ),
      ),
    );
    
    return input;
  }
  
  // Get fruit illustration path
  String getFruitIllustration(String fruitName) {
    // Map fruit names to illustration assets
    final fruitLower = fruitName.toLowerCase().replaceAll(' ', '_');
    return 'assets/fruits/$fruitLower.png';
  }
  
  // Clean up resources
  void dispose() {
    _interpreter?.close();
    _isModelLoaded = false;
  }
  
  bool get isModelLoaded => _isModelLoaded;
  List<String> get labels => _labels;
}

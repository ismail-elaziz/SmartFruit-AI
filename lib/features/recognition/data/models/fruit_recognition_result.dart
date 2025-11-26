class FruitRecognitionResult {
  final String fruitName;
  final double confidence;
  final String imageUrl;
  final DateTime timestamp;
  
  FruitRecognitionResult({
    required this.fruitName,
    required this.confidence,
    required this.imageUrl,
    required this.timestamp,
  });
  
  factory FruitRecognitionResult.fromMap(Map<String, dynamic> map) {
    return FruitRecognitionResult(
      fruitName: map['fruitName'] ?? '',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'fruitName': fruitName,
      'confidence': confidence,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

import 'package:flutter/material.dart';
import '../../data/models/fruit_recognition_result.dart';
import '../../data/services/fruit_recognition_service.dart';

class RecognitionResultCard extends StatelessWidget {
  final FruitRecognitionResult result;

  const RecognitionResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (result.confidence * 100).toStringAsFixed(1);
    final isHighConfidence = result.confidence >= 0.7;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHighConfidence ? Icons.check_circle : Icons.info,
                  color: isHighConfidence ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recognition Result',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        result.fruitName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Confidence bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Confidence',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '$confidencePercent%',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: result.confidence,
                    minHeight: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isHighConfidence ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Fruit illustration
            _buildFruitIllustration(context),
            
            const SizedBox(height: 16),
            
            // Info message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHighConfidence 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isHighConfidence ? Icons.check_circle_outline : Icons.warning_amber,
                    color: isHighConfidence ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isHighConfidence
                          ? 'High confidence detection'
                          : 'Low confidence - Try taking a clearer photo',
                      style: TextStyle(
                        color: isHighConfidence ? Colors.green[800] : Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFruitIllustration(BuildContext context) {
    final illustrationPath = FruitRecognitionService().getFruitIllustration(result.fruitName);
    
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Image.asset(
          illustrationPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.apple,
              size: 60,
              color: Theme.of(context).primaryColor,
            );
          },
        ),
      ),
    );
  }
}

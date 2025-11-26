# Testing Guidelines for SmartFruit

## Table of Contents

1. [Unit Testing](#unit-testing)
2. [Widget Testing](#widget-testing)
3. [Integration Testing](#integration-testing)
4. [Model Testing](#model-testing)
5. [API Testing](#api-testing)
6. [Performance Testing](#performance-testing)

---

## Unit Testing

### Authentication Service Tests

Create `test/features/auth/services/auth_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_fruit/features/auth/data/services/auth_service.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = AuthService();
    });

    test('signIn with valid credentials returns UserModel', () async {
      // Arrange
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockCredential);

      // Act
      final result = await authService.signInWithEmailPassword(
        'test@example.com',
        'password123',
      );

      // Assert
      expect(result.uid, equals('test-uid'));
    });

    test('signIn with invalid credentials throws error', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act & Assert
      expect(
        () => authService.signInWithEmailPassword(
          'invalid@example.com',
          'wrongpassword',
        ),
        throwsA(isA<String>()),
      );
    });

    test('register with valid data creates new user', () async {
      // Test implementation
    });
  });
}
```

Run unit tests:

```powershell
flutter test
```

---

## Widget Testing

### Login Screen Tests

Create `test/features/auth/presentation/screens/login_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_fruit/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen displays email and password fields', (tester) async {
    // Arrange
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Assert
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Email validation shows error for invalid email', (tester) async {
    // Test implementation
  });

  testWidgets('Tapping Sign In with valid credentials navigates to home', (tester) async {
    // Test implementation
  });
}
```

---

## Integration Testing

### End-to-End Test

Create `integration_test/app_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_fruit/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SmartFruit Integration Tests', () {
    testWidgets('Complete user flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to register
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fill registration form
      await tester.enterText(
        find.byType(TextField).at(0),
        'Test User',
      );
      await tester.enterText(
        find.byType(TextField).at(1),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextField).at(2),
        'password123',
      );
      await tester.enterText(
        find.byType(TextField).at(3),
        'password123',
      );

      // Submit
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify home screen
      expect(find.text('SmartFruit'), findsOneWidget);
    });
  });
}
```

Run integration tests:

```powershell
flutter test integration_test/app_test.dart
```

---

## Model Testing

### TFLite Model Validation

Create `test/features/recognition/services/recognition_service_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_fruit/features/recognition/data/services/fruit_recognition_service.dart';

void main() {
  group('FruitRecognitionService Tests', () {
    late FruitRecognitionService service;

    setUp(() async {
      service = FruitRecognitionService();
      await service.loadModel();
    });

    test('Model loads successfully', () {
      expect(service.isModelLoaded, isTrue);
    });

    test('Labels are loaded correctly', () {
      expect(service.labels, isNotEmpty);
      expect(service.labels.length, greaterThan(0));
    });

    test('Recognizes apple with high confidence', () async {
      // Arrange
      final testImage = File('test/assets/apple.jpg');

      // Act
      final result = await service.recognizeFruit(testImage);

      // Assert
      expect(result.fruitName.toLowerCase(), contains('apple'));
      expect(result.confidence, greaterThan(0.7));
    });

    test('Returns result with valid timestamp', () async {
      final testImage = File('test/assets/banana.jpg');
      final result = await service.recognizeFruit(testImage);
      
      expect(result.timestamp, isNotNull);
      expect(result.timestamp.isBefore(DateTime.now()), isTrue);
    });
  });
}
```

### Manual Model Testing

1. **Collect Test Images:**
   - Take 10 photos of each fruit
   - Vary lighting, angles, backgrounds

2. **Run Predictions:**
   ```dart
   for (var image in testImages) {
     final result = await service.recognizeFruit(image);
     print('${result.fruitName}: ${result.confidence}');
   }
   ```

3. **Calculate Metrics:**
   - Accuracy: Correct predictions / Total predictions
   - Average confidence: Sum of confidence / Total predictions
   - Per-fruit accuracy

4. **Expected Results:**
   - Overall accuracy: > 85%
   - Average confidence: > 0.80
   - High-confidence predictions (>0.9): > 60%

---

## API Testing

### AI Assistant API Tests

Create `test/features/assistant/services/ai_assistant_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:smart_fruit/features/assistant/data/services/ai_assistant_service.dart';

@GenerateMocks([http.Client])
void main() {
  group('AIAssistantService Tests', () {
    late AIAssistantService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = AIAssistantService();
    });

    test('sendMessage returns valid response', () async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"choices":[{"message":{"content":"Test response"}}]}',
        200,
      ));

      // Act
      final result = await service.sendMessage('Hello');

      // Assert
      expect(result['success'], isTrue);
      expect(result['message'], isNotEmpty);
    });

    test('sendMessage handles API errors', () async {
      // Test implementation
    });
  });
}
```

### API Rate Limiting Test

```dart
test('Handles rate limiting gracefully', () async {
  int requestCount = 0;
  
  for (int i = 0; i < 100; i++) {
    try {
      await service.sendMessage('Test $i');
      requestCount++;
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print('Rate limit hit after $requestCount requests');
      break;
    }
  }
  
  expect(requestCount, greaterThan(0));
});
```

---

## Performance Testing

### Image Processing Performance

```dart
test('Image processing completes within 3 seconds', () async {
  final stopwatch = Stopwatch()..start();
  
  final result = await service.recognizeFruit(testImage);
  
  stopwatch.stop();
  expect(stopwatch.elapsed.inSeconds, lessThan(3));
});
```

### Memory Usage Test

```dart
test('Multiple recognitions dont cause memory leak', () async {
  for (int i = 0; i < 50; i++) {
    await service.recognizeFruit(testImage);
    // Check memory usage here if possible
  }
  // If no crash, test passes
});
```

### App Startup Time

```dart
testWidgets('App starts within 5 seconds', (tester) async {
  final stopwatch = Stopwatch()..start();
  
  app.main();
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  expect(stopwatch.elapsed.inSeconds, lessThan(5));
});
```

---

## Test Coverage

Generate coverage report:

```powershell
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Open `coverage/html/index.html` in browser.

**Target Coverage:**
- Overall: > 70%
- Critical paths (auth, recognition): > 85%
- UI widgets: > 60%

---

## Continuous Testing

### Setup GitHub Actions

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter test --coverage
```

---

## Manual Testing Checklist

### Authentication
- [ ] Register new account
- [ ] Login with valid credentials
- [ ] Login with invalid credentials
- [ ] Password reset email received
- [ ] Logout successfully
- [ ] Session persists after app restart

### Recognition
- [ ] Camera opens correctly
- [ ] Can select from gallery
- [ ] Recognition completes in < 3s
- [ ] Result displays correctly
- [ ] High confidence (>70%) for clear images
- [ ] Handles poor lighting
- [ ] Handles multiple fruits (shows best match)

### Assistant
- [ ] Text input works
- [ ] Speech recognition works
- [ ] AI responds appropriately
- [ ] Text-to-speech plays
- [ ] Chat history displays
- [ ] Can clear chat

### Navigation
- [ ] All tabs accessible
- [ ] Back button works
- [ ] Deep links work (if implemented)

### Edge Cases
- [ ] No internet connection
- [ ] API quota exceeded
- [ ] Invalid image format
- [ ] Permissions denied
- [ ] Background/foreground transitions

---

## Test Data

### Sample Test Users

```
Email: test1@example.com
Password: Test123!

Email: test2@example.com
Password: Test456!
```

### Sample Test Images

Required test images in `test/assets/`:
- `apple.jpg` - Clear apple photo
- `banana.jpg` - Clear banana photo
- `orange.jpg` - Clear orange photo
- `poor_lighting.jpg` - Fruit in dim light
- `multiple_fruits.jpg` - Multiple fruits
- `not_a_fruit.jpg` - Non-fruit object

---

## Test Report Template

After testing, document results:

```markdown
# Test Report - SmartFruit v1.0.0

**Date:** YYYY-MM-DD
**Tester:** Name
**Environment:** Device, OS Version

## Unit Tests
- Total: 50
- Passed: 48
- Failed: 2
- Coverage: 75%

## Integration Tests
- Total: 10
- Passed: 9
- Failed: 1

## Performance
- App startup: 2.3s
- Recognition time: 1.8s avg
- Memory usage: Stable

## Known Issues
1. Issue description
2. Issue description

## Recommendations
1. Recommendation
2. Recommendation
```

---

**Remember:** Testing is ongoing! Add tests as you add features.

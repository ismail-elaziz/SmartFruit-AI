# 🍎 SmartFruit - Intelligent Fruit Recognition & Voice Assistant

A production-ready Flutter application that uses on-device TensorFlow Lite for fruit recognition and AI-powered voice assistant for nutritional information.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![TensorFlow Lite](https://img.shields.io/badge/TFLite-Enabled-yellow.svg)](https://www.tensorflow.org/lite)

---

## 📱 Features

### ✅ Implemented Features

- **Firebase Authentication**
  - Email/password login and registration
  - Password reset functionality
  - Persistent user sessions
  - Automatic redirect based on auth state

- **Fruit Recognition (TensorFlow Lite)**
  - On-device ML model inference
  - Camera capture and gallery image selection
  - Real-time fruit classification
  - Confidence percentage display
  - Fruit illustration preview

- **AI Voice Assistant**
  - Speech-to-text input
  - Integration with OpenAI GPT or Google Gemini
  - Text-to-speech responses
  - Chat history tracking
  - Natural language processing for fruit/nutrition queries

- **Navigation & UI**
  - Bottom navigation bar
  - Home dashboard
  - Profile management
  - Recognition history
  - About screen

- **State Management**
  - Riverpod for scalable state management
  - AsyncValue for loading/error states
  - Provider-based architecture

---

## 🏗️ Project Structure

```
SmartFruit/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart            # API keys & configuration
│   │   ├── routes/
│   │   │   └── app_router.dart            # App routing logic
│   │   └── theme/
│   │       └── app_theme.dart             # Light & dark themes
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart    # User data model
│   │   │   │   └── services/
│   │   │   │       └── auth_service.dart  # Firebase Auth service
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart # Auth state management
│   │   │       ├── screens/
│   │   │       │   ├── splash_screen.dart
│   │   │       │   ├── login_screen.dart
│   │   │       │   ├── register_screen.dart
│   │   │       │   └── forgot_password_screen.dart
│   │   │       └── widgets/
│   │   │           ├── custom_text_field.dart
│   │   │           └── custom_button.dart
│   │   ├── recognition/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── fruit_recognition_result.dart
│   │   │   │   └── services/
│   │   │   │       └── fruit_recognition_service.dart  # TFLite service
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── recognition_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── recognition_screen.dart
│   │   │       └── widgets/
│   │   │           └── recognition_result_card.dart
│   │   ├── assistant/
│   │   │   ├── data/
│   │   │   │   └── services/
│   │   │   │       ├── ai_assistant_service.dart  # GPT/Gemini API
│   │   │   │       ├── speech_service.dart        # Speech-to-text
│   │   │   │       └── tts_service.dart           # Text-to-speech
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── assistant_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── assistant_screen.dart
│   │   │       └── widgets/
│   │   │           └── chat_message_bubble.dart
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── main_screen.dart
│   │   ├── profile/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── profile_screen.dart
│   │   ├── about/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── about_screen.dart
│   │   └── history/
│   │       └── presentation/
│   │           └── screens/
│   │               └── history_screen.dart
├── android/
│   ├── app/
│   │   ├── build.gradle                   # Android build config
│   │   ├── google-services.json           # Firebase config (Android)
│   │   └── src/main/AndroidManifest.xml   # Permissions
│   └── build.gradle                        # Project-level Gradle
├── ios/
│   └── Runner/
│       ├── Info.plist                      # iOS permissions
│       └── GoogleService-Info.plist        # Firebase config (iOS)
├── assets/
│   ├── models/
│   │   ├── fruit_classifier.tflite         # TFLite model (YOU MUST ADD)
│   │   └── labels.txt                      # Fruit labels (YOU MUST ADD)
│   ├── images/                             # App images
│   ├── fruits/                             # Fruit illustrations
│   └── animations/                         # Lottie animations (optional)
├── pubspec.yaml                            # Dependencies
└── README.md                               # This file
```

---

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK 3.0+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart SDK 3.0+
- Android Studio / Xcode
- Firebase project
- OpenAI API key or Google Gemini API key

### Step 1: Clone and Install Dependencies

```powershell
cd d:\SmartFruit
flutter pub get
```

### Step 2: Configure Firebase

#### 2.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named `SmartFruit`
3. Enable **Authentication** → Email/Password
4. Enable **Cloud Firestore**

#### 2.2 Android Configuration

1. Register Android app with package name: `com.smartfruit.app`
2. Download `google-services.json`
3. Place it in `android/app/google-services.json`
4. Update the file with your actual Firebase credentials

#### 2.3 iOS Configuration

1. Register iOS app with bundle ID: `com.smartfruit.app`
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/GoogleService-Info.plist`
4. Update the file with your actual Firebase credentials

### Step 3: Configure API Keys

Edit `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Replace with your actual keys
  static const String openAIApiKey = 'sk-YOUR_OPENAI_API_KEY_HERE';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  // Choose your preferred AI service
  static bool useOpenAI = false;  // true for OpenAI, false for Gemini
}
```

**Get API Keys:**
- OpenAI: [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
- Google Gemini: [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)

### Step 4: Add TensorFlow Lite Model

You need to train or download a fruit classification model.

#### Option A: Use Pre-trained Model

1. Download a pre-trained fruit classifier from [TensorFlow Hub](https://tfhub.dev/)
2. Convert to TFLite format if needed
3. Place `fruit_classifier.tflite` in `assets/models/`

#### Option B: Train Custom Model

```python
# Example training script (simplified)
import tensorflow as tf

# Train your model
model = tf.keras.Sequential([...])
model.compile(...)
model.fit(...)

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save
with open('fruit_classifier.tflite', 'wb') as f:
    f.write(tflite_model)
```

#### Create Labels File

Create `assets/models/labels.txt`:

```
Apple
Banana
Orange
Grape
Strawberry
Mango
Pineapple
Watermelon
Kiwi
Peach
```

### Step 5: Add Fruit Illustrations

Place fruit images in `assets/fruits/`:

```
assets/fruits/
├── apple.png
├── banana.png
├── orange.png
├── grape.png
└── ...
```

### Step 6: Run the App

```powershell
# Android
flutter run

# iOS (Mac only)
flutter run

# Specific device
flutter run -d <device_id>

# Release build
flutter build apk
flutter build ios
```

---

## 🔧 Configuration

### Firestore Security Rules

Set up security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /recognition_history/{historyId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### Android Permissions

Already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS Permissions

Already configured in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture fruit images</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice assistant</string>
```

---

## 🧪 Testing

### Unit Tests

Create test files in `test/` directory:

```dart
// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AuthService Tests', () {
    test('signIn with valid credentials', () async {
      // Test implementation
    });
  });
}
```

Run tests:

```powershell
flutter test
```

### Integration Tests

```powershell
flutter test integration_test/
```

### Model Validation

Test your TFLite model:

```dart
// Test recognition accuracy
final result = await recognitionService.recognizeFruit(testImage);
expect(result.confidence, greaterThan(0.7));
```

---

## 📊 Architecture

### Clean Architecture

```
Presentation Layer (UI)
      ↓
  Providers (State Management)
      ↓
 Services (Business Logic)
      ↓
  Data Layer (Firebase, TFLite)
```

### State Management - Riverpod

```dart
// Provider Definition
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Usage in Widget
final authState = ref.watch(authStateProvider);
authState.when(
  data: (user) => user != null ? HomeScreen() : LoginScreen(),
  loading: () => LoadingScreen(),
  error: (error, _) => ErrorScreen(error),
);
```

---

## 🔒 Security Best Practices

### ✅ Implemented

- Firebase Authentication for user management
- Firestore security rules
- API keys in separate config file
- Input validation on all forms

### ⚠️ Important for Production

1. **Never commit API keys** to Git
   - Use environment variables
   - Use Flutter dotenv package

2. **Store API keys securely**
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   final apiKey = dotenv.env['OPENAI_API_KEY']!;
   ```

3. **Implement rate limiting** on API calls
4. **Use Cloud Functions** for sensitive API calls
5. **Enable App Check** for Firebase services

---

## 🚀 Performance Optimization

### TFLite Model

- Use quantized models (reduces size by 75%)
- Optimize input image size (224x224 recommended)
- Implement caching for repeated inferences

### Image Handling

- Compress images before processing
- Use `image_picker` with quality settings:
  ```dart
  final image = await picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );
  ```

### API Calls

- Implement request debouncing
- Cache responses where applicable
- Handle network errors gracefully

---

## 📱 Platform-Specific Notes

### Android

- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Supports multi-dex

### iOS

- Minimum iOS: 12.0
- Requires Xcode 14+
- CocoaPods for dependencies

---

## 🐛 Troubleshooting

### Build Issues

**Problem:** Firebase not configured
```
Solution: Ensure google-services.json (Android) and GoogleService-Info.plist (iOS) are properly placed
```

**Problem:** TFLite model not loading
```
Solution: 
1. Verify model path in pubspec.yaml under assets
2. Run 'flutter clean' and 'flutter pub get'
3. Rebuild the app
```

**Problem:** Permission denied errors
```
Solution: Check AndroidManifest.xml and Info.plist have required permissions
```

### Runtime Issues

**Problem:** Speech recognition not working
```
Solution: 
1. Check microphone permission granted
2. Verify device has speech recognition support
3. Test with different phrases
```

**Problem:** API calls failing
```
Solution:
1. Verify API keys are correct
2. Check internet connection
3. Review API quota/billing status
```

---

## 📚 Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # TensorFlow Lite
  tflite_flutter: ^0.10.4
  image_picker: ^1.0.5
  image: ^4.1.3
  
  # Voice & Speech
  speech_to_text: ^6.6.0
  flutter_tts: ^3.8.5
  permission_handler: ^11.1.0
  
  # HTTP & API
  http: ^1.1.2
  
  # UI
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1
```

---

## 🎨 UI/UX Wireframes

### Login Screen
```
┌─────────────────────────┐
│     [SmartFruit Icon]   │
│   Welcome Back!         │
│                         │
│   Email: [___________]  │
│   Password: [________]  │
│                         │
│   [Forgot Password?]    │
│   [    Sign In     ]    │
│   Don't have account?   │
│   [Sign Up]             │
└─────────────────────────┘
```

### Home Screen
```
┌─────────────────────────┐
│ SmartFruit      [History]│
│                         │
│  ┌───────────────────┐ │
│  │  Welcome Card     │ │
│  │  [Icon]           │ │
│  └───────────────────┘ │
│                         │
│  Features:             │
│  ┌─ Fruit Recognition  │
│  ├─ AI Assistant       │
│  ├─ History            │
│  └─ About              │
│                         │
│ [Home][Scan][AI][Me]   │
└─────────────────────────┘
```

### Recognition Screen
```
┌─────────────────────────┐
│ Fruit Recognition   [X] │
│                         │
│  ┌───────────────────┐ │
│  │                   │ │
│  │   [Image Preview] │ │
│  │                   │ │
│  └───────────────────┘ │
│                         │
│  Result: Apple          │
│  Confidence: 94.5%      │
│  [───────────────]      │
│                         │
│  [Capture/Pick Image]   │
└─────────────────────────┘
```

### Assistant Screen
```
┌─────────────────────────┐
│ AI Assistant     [Clear]│
│                         │
│  ┌─ What vitamins...   │
│  └─ Apples contain...   │
│  ┌─ How many calories...│
│  └─ A medium apple...   │
│                         │
│                         │
│  [🎤] [Type message...] │
│                     [→] │
└─────────────────────────┘
```

---

## 🧑‍💻 Development Guidelines

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable names
- Comment complex logic
- Keep functions small and focused

### Git Workflow

```powershell
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/new-feature
```

### Commit Message Format

```
feat: Add new feature
fix: Fix bug
docs: Update documentation
style: Format code
refactor: Refactor code
test: Add tests
chore: Update dependencies
```

---

## 📈 Future Enhancements

- [ ] Offline mode for fruit recognition
- [ ] Multiple fruit detection in one image
- [ ] Nutritional information database
- [ ] Barcode scanning for packaged fruits
- [ ] Recipe suggestions
- [ ] Social sharing features
- [ ] Multi-language support
- [ ] Dark mode improvements
- [ ] Accessibility features
- [ ] Widget for quick recognition

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

---

## 📞 Support

For issues and questions:

- Create an issue in the repository
- Check existing documentation
- Review Firebase console for backend issues

---

## 👨‍💻 Author

**SmartFruit Development Team**

Built with ❤️ using Flutter

---

## 🙏 Acknowledgments

- Firebase for backend services
- TensorFlow Lite for ML capabilities
- OpenAI / Google for AI assistant
- Flutter team for the amazing framework
- All open-source contributors

---

**Happy Coding! 🚀**
#   S m a r t F r u i t - A I  
 
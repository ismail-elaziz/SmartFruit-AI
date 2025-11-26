# 🚀 SmartFruit - Complete Setup Guide

This guide will walk you through every step to get SmartFruit running on your machine.

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] Flutter SDK 3.0 or higher installed
- [ ] Android Studio (for Android development)
- [ ] Xcode (for iOS development, Mac only)
- [ ] Git installed
- [ ] A Firebase account
- [ ] An OpenAI account OR Google Cloud account

---

## Step-by-Step Setup

### 1️⃣ Install Flutter

If you haven't installed Flutter:

**Windows:**
```powershell
# Download Flutter SDK from flutter.dev
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin

# Verify installation
flutter doctor
```

**Mac/Linux:**
```bash
# Download from flutter.dev
# Extract and add to PATH in ~/.zshrc or ~/.bashrc
export PATH="$PATH:`pwd`/flutter/bin"

# Verify
flutter doctor
```

---

### 2️⃣ Clone and Setup Project

```powershell
# Navigate to your projects directory
cd d:\

# If cloning from Git (when available)
# git clone https://github.com/your-repo/SmartFruit.git

# If using the generated code
cd SmartFruit

# Get dependencies
flutter pub get

# Verify everything is installed
flutter doctor -v
```

---

### 3️⃣ Firebase Setup (Detailed)

#### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Project name: `SmartFruit`
4. Disable Google Analytics (optional)
5. Click **"Create project"**

#### 3.2 Enable Authentication

1. In Firebase Console, click **"Authentication"**
2. Click **"Get started"**
3. Under **"Sign-in method"**, enable **"Email/Password"**
4. Click **"Save"**

#### 3.3 Create Firestore Database

1. In Firebase Console, click **"Firestore Database"**
2. Click **"Create database"**
3. Select **"Start in test mode"** (we'll add rules later)
4. Choose a location (closest to your users)
5. Click **"Enable"**

#### 3.4 Setup Firestore Security Rules

In Firestore, go to **"Rules"** tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User documents
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Recognition history subcollection
      match /recognition_history/{historyId} {
        allow create: if request.auth != null && request.auth.uid == userId;
        allow read, update, delete: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

Click **"Publish"**

#### 3.5 Register Android App

1. In Firebase Console, click the **Android icon**
2. Android package name: `com.smartfruit.app`
3. App nickname: `SmartFruit Android`
4. Click **"Register app"**
5. Download `google-services.json`
6. Place it at: `android/app/google-services.json`

#### 3.6 Register iOS App (Mac only)

1. In Firebase Console, click the **iOS icon**
2. iOS bundle ID: `com.smartfruit.app`
3. App nickname: `SmartFruit iOS`
4. Click **"Register app"**
5. Download `GoogleService-Info.plist`
6. Place it at: `ios/Runner/GoogleService-Info.plist`

---

### 4️⃣ Get API Keys

#### Option A: OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up/Login
3. Click on your profile → **"View API keys"**
4. Click **"Create new secret key"**
5. Name it `SmartFruit`
6. Copy the key (starts with `sk-`)
7. ⚠️ **Save it securely - you won't see it again!**

#### Option B: Google Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with Google account
3. Click **"Create API key"**
4. Select a Google Cloud project or create new
5. Copy the API key
6. Save it securely

#### Configure API Keys in App

Open `lib/core/config/app_config.dart` and update:

```dart
class AppConfig {
  // Replace with your actual API keys
  static const String openAIApiKey = 'sk-your-actual-key-here';
  static const String geminiApiKey = 'your-gemini-key-here';
  
  // Set to true for OpenAI, false for Gemini
  static bool useOpenAI = false;  // Change this based on preference
}
```

⚠️ **Security Note:** For production, use environment variables!

---

### 5️⃣ Add TensorFlow Lite Model

You have two options:

#### Option A: Download Pre-trained Model

1. Visit [TensorFlow Hub](https://tfhub.dev/)
2. Search for "fruit classification" or "food classification"
3. Download a compatible model
4. Convert to `.tflite` format if needed:

```python
import tensorflow as tf

# Load model
model = tf.keras.models.load_model('model.h5')

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

# Save
with open('fruit_classifier.tflite', 'wb') as f:
    f.write(tflite_model)
```

5. Place `fruit_classifier.tflite` in `assets/models/`

#### Option B: Use Placeholder (For Development)

Create a simple placeholder:

1. Create `assets/models/` directory
2. For now, you can use any TFLite image classification model
3. Update `labels.txt` to match your model's classes

**Important:** The app is already configured to load the model. You just need to provide it!

---

### 6️⃣ Prepare Asset Files

#### Create Required Directories

```powershell
# Create directories
mkdir assets
mkdir assets\models
mkdir assets\images
mkdir assets\fruits
mkdir assets\animations
```

#### Add Fruit Illustrations (Optional)

Download or create fruit icons/images:

```
assets/fruits/
├── apple.png
├── banana.png
├── orange.png
├── grape.png
├── strawberry.png
└── ... (add more as needed)
```

You can use free resources like:
- [Flaticon](https://www.flaticon.com/)
- [Icons8](https://icons8.com/)
- [Freepik](https://www.freepik.com/)

---

### 7️⃣ Configure Permissions

Permissions are already set up in the generated files, but verify:

**Android** - Check `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

**iOS** - Check `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access needed for fruit recognition</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access needed for voice assistant</string>
```

---

### 8️⃣ Run the App

#### Check Connected Devices

```powershell
flutter devices
```

#### Run on Android

```powershell
# Debug mode
flutter run

# Release mode
flutter run --release
```

#### Run on iOS (Mac only)

```powershell
# Open iOS Simulator
open -a Simulator

# Run app
flutter run
```

#### Build APK (Android)

```powershell
flutter build apk --release
```

Find APK at: `build/app/outputs/flutter-apk/app-release.apk`

---

### 9️⃣ Test the App

#### Create Test Account

1. Run the app
2. Click **"Sign Up"**
3. Enter:
   - Name: Test User
   - Email: test@example.com
   - Password: test123
4. Click **"Sign Up"**

#### Test Features

1. **Home Screen:** Should show welcome card and features
2. **Recognition:**
   - Take a photo of a fruit
   - Should show classification result
3. **Assistant:**
   - Tap microphone or type a message
   - Ask: "What are the benefits of apples?"
   - Should get AI response with voice output
4. **Profile:** View your profile information
5. **History:** View past recognitions

---

## 🐛 Common Issues & Solutions

### Issue: "Gradle build failed"

**Solution:**
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "Firebase not configured"

**Solution:**
1. Verify `google-services.json` is in `android/app/`
2. Verify `GoogleService-Info.plist` is in `ios/Runner/`
3. Check package name matches Firebase registration

### Issue: "TFLite model not found"

**Solution:**
1. Ensure model is in `assets/models/fruit_classifier.tflite`
2. Run `flutter clean && flutter pub get`
3. Rebuild app

### Issue: "API calls failing"

**Solution:**
1. Check internet connection
2. Verify API key in `app_config.dart`
3. Check API quota/billing in respective console
4. Review error messages in console

### Issue: "Permission denied for camera/microphone"

**Solution:**
1. Go to device Settings → Apps → SmartFruit
2. Enable Camera and Microphone permissions
3. Restart app

### Issue: "Speech recognition not working"

**Solution:**
1. Check microphone permission
2. Ensure device has active internet (speech recognition requires it)
3. Try different phrases
4. Check device compatibility

---

## 🧪 Testing Checklist

Before considering setup complete:

- [ ] App launches successfully
- [ ] Can register a new account
- [ ] Can login with registered account
- [ ] Home screen displays correctly
- [ ] Can access all navigation tabs
- [ ] Camera opens for fruit recognition
- [ ] Can select image from gallery
- [ ] AI assistant responds to messages
- [ ] Speech-to-text works
- [ ] Text-to-speech works
- [ ] Can logout successfully
- [ ] Password reset sends email

---

## 📊 Development vs Production

### Development Setup (Current)

- API keys in `app_config.dart`
- Test mode Firestore rules
- Debug builds
- Local testing

### Production Setup (Recommended)

1. **Use Environment Variables:**
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   final apiKey = dotenv.env['API_KEY']!;
   ```

2. **Secure Firestore Rules**
3. **Enable Firebase App Check**
4. **Use ProGuard (Android)**
5. **Enable BitCode (iOS)**
6. **Implement Analytics**
7. **Add Crash Reporting**

---

## 🎯 Next Steps

After successful setup:

1. **Train/Fine-tune ML Model** with your fruit dataset
2. **Customize UI** to match your brand
3. **Add More Fruits** to recognition database
4. **Implement Caching** for better performance
5. **Add Unit Tests**
6. **Setup CI/CD** for automated deployments
7. **Publish to App Stores**

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [TensorFlow Lite Guide](https://www.tensorflow.org/lite/guide)
- [Riverpod Documentation](https://riverpod.dev/)
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Gemini API Docs](https://ai.google.dev/docs)

---

## 💬 Get Help

If you're stuck:

1. Check the **Troubleshooting** section above
2. Review Firebase Console for errors
3. Check Flutter console output
4. Review API documentation
5. Check GitHub issues (if using Git)

---

## ✅ Setup Complete!

If you've followed all steps, your SmartFruit app should be running! 🎉

**Test it thoroughly and enjoy building!** 🚀

---

*Last Updated: November 2025*

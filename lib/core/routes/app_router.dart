import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/recognition/presentation/screens/recognition_screen.dart';
import '../../features/assistant/presentation/screens/assistant_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String recognition = '/recognition';
  static const String assistant = '/assistant';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String history = '/history';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      
      case recognition:
        return MaterialPageRoute(builder: (_) => const RecognitionScreen());
      
      case assistant:
        return MaterialPageRoute(builder: (_) => const AssistantScreen());
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

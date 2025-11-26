import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/app_config.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize app configuration
  await AppConfig.initialize();
  
  runApp(const ProviderScope(child: SmartFruitApp()));
}

class SmartFruitApp extends ConsumerWidget {
  const SmartFruitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      title: 'SmartFruit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: authState.when(
        data: (user) => user != null ? AppRouter.home : AppRouter.login,
        loading: () => AppRouter.splash,
        error: (_, __) => AppRouter.login,
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

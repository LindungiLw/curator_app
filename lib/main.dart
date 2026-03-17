import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const CuratorApp());
}

class CuratorApp extends StatelessWidget {
  const CuratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CURATOR AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.obsidianBlack,
        primaryColor: AppColors.amethystGlow,

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.silverAsh, fontFamily: 'Inter'),
          titleLarge: TextStyle(color: AppColors.silverAsh, fontFamily: 'Playfair Display'),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
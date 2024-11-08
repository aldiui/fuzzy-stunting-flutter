import 'package:flutter/material.dart';
import 'package:stunting_android/screens/analyzer_page.dart';
import 'package:stunting_android/screens/article_page.dart';
import 'package:stunting_android/screens/consultation_page.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'theme/color_schemes.dart';
import 'theme/text_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CERDAS',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: lightColorScheme,
        textTheme: textTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SolaceApp());
}

class SolaceApp extends StatelessWidget {
  const SolaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solace',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}

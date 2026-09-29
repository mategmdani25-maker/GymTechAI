import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() => runApp(const GymTechApp());

class GymTechApp extends StatelessWidget {
  const GymTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymTechAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFCCFF00), // Amarillo/Verde neón deportivo
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: const ALUConnectApp(),
    ),
  );
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B21B6),
          primary: const Color(0xFF5B21B6),
          secondary: const Color(0xFF8B5CF6),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/saved',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/saved': (context) => const SavedScreen(),
      },
    );
  }
}
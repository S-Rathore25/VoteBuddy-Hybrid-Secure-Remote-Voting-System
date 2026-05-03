import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voting_provider.dart';
import 'language_provider.dart';
import 'screens.dart';
import 'theme.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VotingProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const VoteBuddyApp(),
    ),
  );
}

class VoteBuddyApp extends StatelessWidget {
  const VoteBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoteBuddy Hybrid',
      theme: appTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VotingProvider>();
    if (provider.hasVoted) {
      return const ConfirmationScreen();
    }
    return const LoginScreen();
  }
}
